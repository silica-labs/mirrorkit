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

    init(executor: CommandExecutor = CommandExecutor()) {
        self.executor = executor
    }

    func setBrewRemote(_ source: MirrorSource) async throws {
        let brewPath = try await brewRepositoryPath()
        if let remoteURL = source.brewGitRemote {
            let result = try await executor.run("git", arguments: ["-C", brewPath, "remote", "set-url", "origin", remoteURL])
            guard result.exitCode == 0 else {
                throw GitRemoteError.exitCode(result.exitCode, result.stderr)
            }
        }
    }

    func restoreOfficial() async throws {
        let brewPath = try await brewRepositoryPath()
        let result = try await executor.run("git", arguments: ["-C", brewPath, "remote", "set-url", "origin", officialBrewRemote])
        guard result.exitCode == 0 else {
            throw GitRemoteError.exitCode(result.exitCode, result.stderr)
        }
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
