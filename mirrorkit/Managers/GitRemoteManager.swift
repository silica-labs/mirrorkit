import Foundation

private let officialBrewRemote = "https://github.com/Homebrew/brew.git"

enum GitRemoteError: Error, LocalizedError {
    case exitCode(Int32, String)
    case invalidOutput(String)

    var errorDescription: String? {
        switch self {
        case .exitCode(let code, let stderr):
            return stderr.isEmpty ? "git 命令退出码: \(code)" : stderr
        case .invalidOutput(let detail):
            return "无法解析 git 输出: \(detail)"
        }
    }
}

final class GitRemoteManager {
    private let executor: CommandExecutor
    private let defaults = UserDefaults.standard
    private let savedOriginKey = "mirrorkit.savedBrewOrigin"

    private var savedOrigin: String? {
        get { defaults.string(forKey: savedOriginKey) }
        set { defaults.set(newValue, forKey: savedOriginKey) }
    }

    init(executor: CommandExecutor = CommandExecutor()) {
        self.executor = executor
    }

    func setBrewRemote(_ source: MirrorSource) async throws {
        let brewPath = try await brewRepositoryPath()
        if savedOrigin == nil {
            savedOrigin = try await getCurrentOrigin(brewPath: brewPath)
        }

        if let remoteURL = source.brewGitRemote {
            let result = try await executor.run("git", arguments: ["-C", brewPath, "remote", "set-url", "origin", remoteURL])
            guard result.exitCode == 0 else {
                throw GitRemoteError.exitCode(result.exitCode, result.stderr)
            }
        }
    }

    func restoreOfficial() async throws {
        let brewPath = try await brewRepositoryPath()
        let origin = savedOrigin ?? officialBrewRemote
        let result = try await executor.run("git", arguments: ["-C", brewPath, "remote", "set-url", "origin", origin])
        guard result.exitCode == 0 else {
            throw GitRemoteError.exitCode(result.exitCode, result.stderr)
        }
        savedOrigin = nil
    }

    private func getCurrentOrigin(brewPath: String) async throws -> String {
        let result = try await executor.run("git", arguments: ["-C", brewPath, "remote", "get-url", "origin"])
        guard result.exitCode == 0 else {
            throw GitRemoteError.exitCode(result.exitCode, result.stderr)
        }
        let origin = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !origin.isEmpty else {
            throw GitRemoteError.invalidOutput("空白输出")
        }
        return origin
    }

    private func brewRepositoryPath() async throws -> String {
        let result = try await executor.run("brew", arguments: ["--repository"])
        guard result.exitCode == 0 else {
            throw GitRemoteError.exitCode(result.exitCode, result.stderr)
        }
        let path = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !path.isEmpty else {
            throw GitRemoteError.invalidOutput("空白输出")
        }
        return path
    }
}
