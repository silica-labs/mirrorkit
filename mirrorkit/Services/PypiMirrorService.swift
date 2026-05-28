import Foundation

final class PypiMirrorService {
    private let executor = CommandExecutor()
    private let defaults = UserDefaults.standard
    private let activeIdKey = "mirrorkit.pypiMirrorId"

    var activeMirrorId: String {
        get { defaults.string(forKey: activeIdKey) ?? "official" }
        set { defaults.set(newValue, forKey: activeIdKey) }
    }

    func applyMirror(_ mirror: PypiMirror) async throws {
        if let url = mirror.mirrorURL {
            try await executor.run("pip", arguments: ["config", "set", "global.index-url", url])
            if let host = mirror.trustedHost {
                try? await executor.run("pip", arguments: ["config", "set", "global.trusted-host", host])
            }
        } else {
            try await executor.run("pip", arguments: ["config", "unset", "global.index-url"])
            try? await executor.run("pip", arguments: ["config", "unset", "global.trusted-host"])
        }
        activeMirrorId = mirror.id
    }
}
