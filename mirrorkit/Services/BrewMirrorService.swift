import Foundation

@MainActor
final class BrewMirrorService {
    static let shared = BrewMirrorService()

    private let shellConfig = ShellConfigService()
    private let gitManager = GitRemoteManager()
    private let prefs = BrewMirrorPreferenceStore.shared

    var activeMirrorId: String {
        get { prefs.selectedMirrorId ?? BrewMirror.allPresets.first(where: { !$0.isOfficial })?.id ?? "tsinghua" }
        set { prefs.selectedMirrorId = newValue }
    }

    func selectMirror(_ source: BrewMirror) async throws {
        if source.isOfficial {
            try await resetToOfficial()
            return
        }

        var errors: [Error] = []

        do {
            try await shellConfig.applyMirrorConfig(source)
        } catch {
            errors.append(error)
        }

        do {
            try await gitManager.setBrewRemote(source)
        } catch {
            if !errors.isEmpty {
                try? shellConfig.restoreBackup()
            }
            errors.append(error)
        }

        if let first = errors.first {
            throw MirrorError.multiple(errors: errors, first: first)
        }

        activeMirrorId = source.id
    }

    func resetToOfficial() async throws {
        try await shellConfig.resetToOfficial()
        try await gitManager.restoreOfficial()
        activeMirrorId = "official"
    }
}

enum MirrorError: Error, LocalizedError {
    case multiple(errors: [Error], first: Error)
    case brewNotInstalled
    case shellProfileWriteFailed(String)

    var errorDescription: String? {
        switch self {
        case .multiple(let errors, _):
            let descriptions = errors.compactMap { ($0 as? LocalizedError)?.errorDescription }
            return descriptions.isEmpty ? "操作失败" : descriptions.joined(separator: "; ")
        case .brewNotInstalled:
            return "Homebrew 未安装"
        case .shellProfileWriteFailed(let detail):
            return "配置文件写入失败: \(detail)"
        }
    }
}
