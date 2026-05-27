import Foundation

final class ShellConfigService {
    private let markerStart = "# --- MirrorKit Managed ---"
    private let markerEnd = "# --- End MirrorKit ---"
    private let backupSuffix = ".mirrorkit.bak"

    func applyMirrorConfig(_ source: MirrorSource) async throws {
        let path = try shellProfilePath()
        let envVars = MirrorEnvironmentBuilder.environmentVariables(mirror: source)
        let newBlock = buildBlock(envVars)

        let newContent: String
        if !FileManager.default.fileExists(atPath: path) {
            newContent = newBlock.hasSuffix("\n") ? newBlock : newBlock + "\n"
        } else {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            if let startRange = content.range(of: markerStart) {
                let afterStart = content[startRange.upperBound...]
                if let endRange = afterStart.range(of: markerEnd) {
                    let fullRange = startRange.lowerBound..<endRange.upperBound
                    newContent = content.replacingCharacters(in: fullRange, with: newBlock)
                } else {
                    newContent = content + "\n" + newBlock
                }
            } else {
                newContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    + "\n\n" + newBlock + "\n"
            }
            try backup(path)
        }

        try newContent.write(toFile: path, atomically: true, encoding: .utf8)
    }

    func resetToOfficial() async throws {
        let path = try shellProfilePath()
        guard FileManager.default.fileExists(atPath: path) else { return }
        let content = try String(contentsOfFile: path, encoding: .utf8)

        guard let startRange = content.range(of: markerStart) else { return }
        let afterStart = content[startRange.upperBound...]
        guard let endRange = afterStart.range(of: markerEnd) else { return }

        let fullRange = startRange.lowerBound..<endRange.upperBound
        let newContent = content.replacingCharacters(in: fullRange, with: "")
            .replacingOccurrences(of: "\n\n\n", with: "\n\n")

        try backup(path)
        try newContent.write(toFile: path, atomically: true, encoding: .utf8)
    }

    private func shellProfilePath() throws -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        let shell = ProcessInfo.processInfo.environment["SHELL"] ?? ""

        if shell.hasSuffix("/zsh") {
            return home + "/.zshrc"
        }
        if shell.hasSuffix("/bash") {
            let bashProfile = home + "/.bash_profile"
            if FileManager.default.fileExists(atPath: bashProfile) { return bashProfile }
            return home + "/.bashrc"
        }

        let zshrc = home + "/.zshrc"
        if FileManager.default.fileExists(atPath: zshrc) { return zshrc }
        let bashProfile = home + "/.bash_profile"
        if FileManager.default.fileExists(atPath: bashProfile) { return bashProfile }
        let bashrc = home + "/.bashrc"
        if FileManager.default.fileExists(atPath: bashrc) { return bashrc }
        return zshrc
    }

    private func buildBlock(_ envVars: [String: String]) -> String {
        guard !envVars.isEmpty else { return "" }
        var lines = [markerStart]
        for (key, value) in envVars.sorted(by: { $0.key < $1.key }) {
            lines.append("export \(key)=\"\(value)\"")
        }
        lines.append(markerEnd)
        return lines.joined(separator: "\n") + "\n"
    }

    private func backup(_ path: String) throws {
        let backupPath = path + backupSuffix
        try? FileManager.default.removeItem(atPath: backupPath)
        try FileManager.default.copyItem(atPath: path, toPath: backupPath)
    }

    func restoreBackup() throws {
        let path = try shellProfilePath()
        let backupPath = path + backupSuffix
        guard FileManager.default.fileExists(atPath: backupPath) else { return }
        try? FileManager.default.removeItem(atPath: path)
        try FileManager.default.moveItem(atPath: backupPath, toPath: path)
    }
}
