import Foundation

final class GoMirrorService {
    private let defaults = UserDefaults.standard
    private let activeIdKey = "mirrorkit.goMirrorId"
    private let markerStart = "# --- MirrorKit Go ---"
    private let markerEnd = "# --- End MirrorKit ---"

    var activeMirrorId: String {
        get { defaults.string(forKey: activeIdKey) ?? "official" }
        set { defaults.set(newValue, forKey: activeIdKey) }
    }

    func applyMirror(_ mirror: GoMirror) async throws {
        let path = try ShellProfileManager.shellProfilePath()
        let block = buildBlock(mirror)
        if block.isEmpty {
            try ShellProfileManager.removeBlock(from: path, markerStart: markerStart, markerEnd: markerEnd)
        } else {
            try ShellProfileManager.writeBlock(block, to: path, markerStart: markerStart, markerEnd: markerEnd)
        }
        activeMirrorId = mirror.id
    }

    private func buildBlock(_ mirror: GoMirror) -> String {
        guard let url = mirror.proxyURL else { return "" }
        var lines = [markerStart]
        lines.append("export GOPROXY=\"\(url),direct\"")
        lines.append(markerEnd)
        return lines.joined(separator: "\n") + "\n"
    }
}
