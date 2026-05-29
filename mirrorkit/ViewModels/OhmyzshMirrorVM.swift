import Foundation
import Observation

@MainActor
@Observable
final class OhmyzshMirrorVM {
    let mirrors = OhmyzshMirror.allPresets
    var latencyResults: [String: TimeInterval] = [:]
    var isMeasuring = false
    var isSwitching = false
    var lastMeasured: Date?
    var logs: [LogEntry] = []
    var activeMirrorId: String

    let isInstalled: Bool

    private let service = OhmyzshMirrorService()
    private let measurer = LatencyMeasurer()

    init() {
        activeMirrorId = service.activeMirrorId
        isInstalled = OhmyzshMirrorService.isInstalled()
    }

    var maxLatency: TimeInterval {
        let values = latencyResults.values.filter { $0 > 0 && $0.isFinite }
        return (values.max() ?? 200) * 1.2
    }

    var activeMirror: OhmyzshMirror {
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
                        let latency = await self.measurer.measure(url: mirror.testURL, timeoutInterval: 10)
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

    func requestSwitch(to mirror: OhmyzshMirror) {
        performSwitch(to: mirror)
    }

    private func performSwitch(to mirror: OhmyzshMirror) {
        Task {
            isSwitching = true
            do {
                try await service.applyMirror(mirror)
                activeMirrorId = mirror.id

                let isOfficial = mirror.id == "official"
                let icon = isOfficial ? "globe" : "checkmark.circle"
                let msg = isOfficial ? "已恢复 Oh My Zsh 官方源" : "已切换到 \(mirror.name)"
                let cmd = "git -C \(OhmyzshMirrorService.zshPath) remote set-url origin \(mirror.gitRemoteURL)"
                logs.insert(LogEntry(icon: icon, message: msg, detail: cmd, timestamp: Date()), at: 0)
            } catch {
                logs.insert(LogEntry(icon: "xmark.circle", message: "切换失败", detail: error.localizedDescription, timestamp: Date()), at: 0)
            }
            isSwitching = false
        }
    }
}
