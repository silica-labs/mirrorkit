import Foundation

final class GitHubMirrorService {
    private let executor = CommandExecutor()
    private let defaults = UserDefaults.standard
    private let activeIdKey = "mirrorkit.gitHubMirrorId"
    private let prevURLKey = "mirrorkit.prevGitHubMirrorURL"

    var activeMirrorId: String {
        get { defaults.string(forKey: activeIdKey) ?? "official" }
        set { defaults.set(newValue, forKey: activeIdKey) }
    }

    private var previousMirrorURL: String? {
        get { defaults.string(forKey: prevURLKey) }
        set { defaults.set(newValue, forKey: prevURLKey) }
    }

    func applyMirror(_ mirror: GitHubMirror) async throws {
        if let prevURL = previousMirrorURL {
            try? await executor.run("git", arguments: ["config", "--global", "--unset-all", "url.\(prevURL).insteadOf"])
            try? await executor.run("git", arguments: ["config", "--global", "--unset-all", "url.https://github.com/.pushInsteadOf"])
        }

        if let mirrorURL = mirror.mirrorURL {
            try await executor.run("git", arguments: ["config", "--global", "--add", "url.\(mirrorURL).insteadOf", "https://github.com/"])
            try await executor.run("git", arguments: ["config", "--global", "--add", "url.https://github.com/.pushInsteadOf", mirrorURL])
            previousMirrorURL = mirrorURL
        } else {
            previousMirrorURL = nil
        }

        activeMirrorId = mirror.id
    }
}
