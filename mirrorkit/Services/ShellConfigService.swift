import Foundation

final class ShellConfigService {
    private let markerStart = "# --- MirrorKit Managed ---"
    private let markerEnd = "# --- End MirrorKit ---"

    func applyMirrorConfig(_ source: MirrorSource) async throws {
        let path = try ShellProfileManager.shellProfilePath()
        let envVars = MirrorEnvironmentBuilder.environmentVariables(mirror: source)
        let block = buildBlock(envVars)
        try ShellProfileManager.writeBlock(block, to: path, markerStart: markerStart, markerEnd: markerEnd)
    }

    func resetToOfficial() async throws {
        let path = try ShellProfileManager.shellProfilePath()
        try ShellProfileManager.removeBlock(from: path, markerStart: markerStart, markerEnd: markerEnd)
    }

    func restoreBackup() throws {
        let path = try ShellProfileManager.shellProfilePath()
        try ShellProfileManager.restoreBackup(from: path)
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
}
