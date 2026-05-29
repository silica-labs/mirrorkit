import Foundation
import Observation

@MainActor
@Observable
final class BrewMirrorVM {
    let mirrors = BrewMirror.allPresets
    var latencyResults: [String: TimeInterval] = [:]
    var isMeasuring = false
    var isSwitching = false
    var lastMeasured: Date?
    var logs: [LogEntry] = []
    var activeMirrorId: String

    let isInstalled: Bool

    private let service = BrewMirrorService.shared
    private let measurer = LatencyMeasurer()

    init() {
        activeMirrorId = service.activeMirrorId
        isInstalled = BrewMirrorService.isInstalled()
    }

    var maxLatency: TimeInterval {
        let values = latencyResults.values.filter { $0 > 0 && $0.isFinite }
        return (values.max() ?? 200) * 1.2
    }

    var activeMirror: BrewMirror {
        mirrors.first(where: { $0.id == activeMirrorId }) ?? mirrors[0]
    }

    var elapsedSinceLastMeasured: String? {
        guard let last = lastMeasured else { return nil }
        let interval = Date().timeIntervalSince(last)
        if interval < 60 { return "\(Int(interval))秒前" }
        return "\(Int(interval / 60))分钟前"
    }

    func startSpeedTest() {
        guard !isMeasuring else { return }
        isMeasuring = true
        latencyResults = [:]

        Task {
            await withTaskGroup(of: (String, TimeInterval).self) { group in
                for mirror in mirrors {
                    group.addTask {
                        let latency = await self.measurer.measure(url: mirror.testURL)
                        return (mirror.id, latency)
                    }
                }
                for await (id, latency) in group {
                    latencyResults[id] = latency
                }
            }
            isMeasuring = false
            lastMeasured = Date()
        }
    }

    func confirmSwitch(to mirror: BrewMirror) {
        performSwitch(to: mirror)
    }

    private func performSwitch(to mirror: BrewMirror) {
        Task {
            isSwitching = true
            do {
                try await service.selectMirror(mirror)
                activeMirrorId = mirror.id

                let icon = mirror.isOfficial ? "globe" : "checkmark.circle"
                let msg: String
                if mirror.isOfficial {
                    msg = "已恢复 Homebrew 官方源"
                } else {
                    msg = "已切换到 \(mirror.name)"
                }
                let detail = "Brew Git Remote: \(mirror.brewGitRemote ?? "https://github.com/Homebrew/brew.git")\nBOTTLE_DOMAIN: \(mirror.bottleDomain ?? "（默认）")\nAPI_DOMAIN: \(mirror.apiDomain ?? "（默认）")"
                logs.insert(LogEntry(icon: icon, message: msg, detail: detail, timestamp: Date()), at: 0)
            } catch {
                logs.insert(LogEntry(icon: "xmark.circle", message: "切换失败", detail: error.localizedDescription, timestamp: Date()), at: 0)
            }
            isSwitching = false
        }
    }
}
