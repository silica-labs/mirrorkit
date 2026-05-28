import Foundation

final class NodeMirrorService {
    private let defaults = UserDefaults.standard
    private let activeIdKey = "mirrorkit.nodeMirrorId"
    private let markerStart = "# --- MirrorKit Node ---"
    private let markerEnd = "# --- End MirrorKit ---"

    var activeMirrorId: String {
        get { defaults.string(forKey: activeIdKey) ?? "official" }
        set { defaults.set(newValue, forKey: activeIdKey) }
    }

    func applyMirror(_ mirror: NodeMirror) async throws {
        let path = try ShellProfileManager.shellProfilePath()
        let block = buildBlock(mirror)
        try ShellProfileManager.writeBlock(block, to: path, markerStart: markerStart, markerEnd: markerEnd)
        activeMirrorId = mirror.id
    }

    func resetToOfficial() async throws {
        let path = try ShellProfileManager.shellProfilePath()
        try ShellProfileManager.removeBlock(from: path, markerStart: markerStart, markerEnd: markerEnd)
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
}
