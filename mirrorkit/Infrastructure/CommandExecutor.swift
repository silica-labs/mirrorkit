import Foundation

actor CommandExecutor {
    enum ExecError: Error, LocalizedError {
        case commandNotFound(String)
        case timedOut(String)

        var errorDescription: String? {
            switch self {
            case .commandNotFound(let cmd):
                return "command not found: \(cmd)"
            case .timedOut(let cmd):
                return "timed out: \(cmd)"
            }
        }
    }

    struct Result {
        let stdout: String
        let stderr: String
        let exitCode: Int32
    }

    private static let searchPaths = [
        "/opt/homebrew/bin",
        "/usr/local/bin",
        "/usr/bin",
        "/bin",
        "/usr/sbin",
        "/sbin",
        "/opt/homebrew/Library/Homebrew/bin",
    ]

    @discardableResult
    func run(_ executable: String, arguments: [String] = [], timeout: Duration = .seconds(30)) async throws -> Result {
        let process = Process()
        process.executableURL = try resolveURL(for: executable)
        process.arguments = arguments

        var env = ProcessInfo.processInfo.environment
        let pathEnv = CommandExecutor.searchPaths.joined(separator: ":")
        if let existingPath = env["PATH"] {
            env["PATH"] = "\(pathEnv):\(existingPath)"
        } else {
            env["PATH"] = pathEnv
        }
        process.environment = env

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        return try await withThrowingTaskGroup(of: Result.self) { group in
            group.addTask {
                try await withCheckedThrowingContinuation { continuation in
                    process.terminationHandler = { p in
                        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
                        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
                        let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
                        let stderr = String(data: stderrData, encoding: .utf8) ?? ""
                        continuation.resume(returning: Result(stdout: stdout, stderr: stderr, exitCode: p.terminationStatus))
                    }
                    do {
                        try process.run()
                    } catch {
                        continuation.resume(throwing: error)
                        return
                    }
                }
            }
            group.addTask {
                try await Task.sleep(for: timeout)
                process.terminate()
                throw ExecError.timedOut(executable)
            }

            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }

    private func resolveURL(for executable: String) throws -> URL {
        if executable.hasPrefix("/") {
            return URL(fileURLWithPath: executable)
        }
        for dir in CommandExecutor.searchPaths {
            let fullPath = "\(dir)/\(executable)"
            if FileManager.default.isExecutableFile(atPath: fullPath) {
                return URL(fileURLWithPath: fullPath)
            }
        }
        throw ExecError.commandNotFound(executable)
    }
}
