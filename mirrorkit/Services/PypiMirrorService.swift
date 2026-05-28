import Foundation

final class PypiMirrorService {
    private let executor = CommandExecutor()
    private let defaults = UserDefaults.standard
    private let activeIdKey = "mirrorkit.pypiMirrorId"
    private static let pipCandidates = ["pip3", "pip"]

    var activeMirrorId: String {
        get { defaults.string(forKey: activeIdKey) ?? "official" }
        set { defaults.set(newValue, forKey: activeIdKey) }
    }

    func applyMirror(_ mirror: PypiMirror) async throws {
        if let url = mirror.mirrorURL {
            try await runPip(["config", "set", "global.index-url", url])
            if let host = mirror.trustedHost {
                try? await runPip(["config", "set", "global.trusted-host", host])
            }
        } else {
            try await runPip(["config", "unset", "global.index-url"])
            try? await runPip(["config", "unset", "global.trusted-host"])
        }
        activeMirrorId = mirror.id
    }

    private func runPip(_ arguments: [String]) async throws {
        for cmd in PypiMirrorService.pipCandidates {
            do {
                let result = try await executor.run(cmd, arguments: arguments)
                if result.exitCode != 0 {
                    let detail = result.stderr.trimmingCharacters(in: .whitespacesAndNewlines)
                    throw ExecError.pipFailed(detail.isEmpty ? "pip 返回错误码 \(result.exitCode)" : detail)
                }
                return
            } catch let error as CommandExecutor.ExecError {
                if case .commandNotFound = error {
                    continue
                }
                throw error
            }
        }

        throw ExecError.notFound
    }
}

extension PypiMirrorService {
    enum ExecError: Error, LocalizedError {
        case notFound
        case pipFailed(String)

        var errorDescription: String? {
            switch self {
            case .notFound:
                return "未找到 pip/pip3，请安装 Python 和 pip"
            case .pipFailed(let detail):
                return "pip 执行失败: \(detail)"
            }
        }
    }
}
