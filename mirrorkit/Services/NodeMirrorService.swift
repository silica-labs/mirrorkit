import Foundation

final class NodeMirrorService {
    private let defaults = UserDefaults.standard
    private let activeIdKey = "mirrorkit.nodeMirrorId"
    private let markerStart = "# --- MirrorKit Node ---"
    private let markerEnd = "# --- End MirrorKit ---"
    private let backupSuffix = ".mirrorkit.bak"

    var activeMirrorId: String {
        get { defaults.string(forKey: activeIdKey) ?? "official" }
        set { defaults.set(newValue, forKey: activeIdKey) }
    }

    func applyMirror(_ mirror: NodeMirror) async throws {
        let path = try shellProfilePath()
        let block = buildBlock(mirror)

        let newContent: String
        if !FileManager.default.fileExists(atPath: path) {
            newContent = block.hasSuffix("\n") ? block : block + "\n"
        } else {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            if let startRange = content.range(of: markerStart) {
                let afterStart = content[startRange.upperBound...]
                if let endRange = afterStart.range(of: markerEnd) {
                    let fullRange = startRange.lowerBound..<endRange.upperBound
                    newContent = content.replacingCharacters(in: fullRange, with: block)
                } else {
                    newContent = content + "\n" + block
                }
            } else {
                newContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    + "\n\n" + block + "\n"
            }
            try backup(path)
        }

        try newContent.write(toFile: path, atomically: true, encoding: .utf8)
        activeMirrorId = mirror.id
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
        activeMirrorId = "official"
    }

    private func buildBlock(_ mirror: NodeMirror) -> String {
        guard let url = mirror.mirrorURL else { return "" }
        var lines = [markerStart]
        lines.append("export NVM_NODEJS_ORG_MIRROR=\"\(url)\"")
        lines.append("export N_NODE_MIRROR=\"\(url)\"")
        lines.append("export FNM_NODE_DIST_MIRROR=\"\(url)\"")
        lines.append(markerEnd)
        return lines.joined(separator: "\n") + "\n"
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

    private func backup(_ path: String) throws {
        let backupPath = path + backupSuffix
        try? FileManager.default.removeItem(atPath: backupPath)
        try FileManager.default.copyItem(atPath: path, toPath: backupPath)
    }

}
