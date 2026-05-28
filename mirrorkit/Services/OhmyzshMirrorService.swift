import Foundation

@MainActor
final class OhmyzshMirrorService {
    private let defaults = UserDefaults.standard
    private let activeIdKey = "mirrorkit.ohmyzshMirrorId"

    static var zshPath: String {
        ProcessInfo.processInfo.environment["ZSH"] ?? "\(NSHomeDirectory())/.oh-my-zsh"
    }

    var activeMirrorId: String {
        get { defaults.string(forKey: activeIdKey) ?? "official" }
        set { defaults.set(newValue, forKey: activeIdKey) }
    }

    static func isInstalled() -> Bool {
        FileManager.default.fileExists(atPath: Self.zshPath + "/.git")
    }

    func applyMirror(_ mirror: OhmyzshMirror) async throws {
        try await CommandExecutor().run(
            "git",
            arguments: ["-C", Self.zshPath, "remote", "set-url", "origin", mirror.gitRemoteURL],
            timeout: .seconds(10)
        )
        activeMirrorId = mirror.id
    }
}
