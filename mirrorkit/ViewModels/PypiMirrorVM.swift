import Foundation
import Observation

@MainActor
@Observable
final class PypiMirrorVM {
    let mirrors = PypiMirror.allPresets
    var latencyResults: [String: TimeInterval] = [:]
    var isMeasuring = false
    var isSwitching = false
    var lastMeasured: Date?
    var logs: [LogEntry] = []
    var activeMirrorId: String

    let isInstalled: Bool

    private let service = PypiMirrorService()
    private let measurer = LatencyMeasurer()

    init() {
        activeMirrorId = service.activeMirrorId
        isInstalled = PypiMirrorService.isInstalled()
    }

    var maxLatency: TimeInterval {
        let values = latencyResults.values.filter { $0 > 0 && $0.isFinite }
        return (values.max() ?? 200) * 1.2
    }

    var activeMirror: PypiMirror {
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

    func requestSwitch(to mirror: PypiMirror) {
        performSwitch(to: mirror)
    }

    private func performSwitch(to mirror: PypiMirror) {
        Task {
            isSwitching = true
            do {
                try await service.applyMirror(mirror)
                activeMirrorId = mirror.id

                let icon = mirror.isOfficial ? "globe" : "checkmark.circle"
                let msg: String
                if mirror.isOfficial {
                    msg = "已恢复 PyPI 官方源"
                } else {
                    msg = "已切换到 \(mirror.name)"
                }
                let detail = "index-url: \(mirror.mirrorURL ?? "（已清除）")"
                logs.insert(LogEntry(icon: icon, message: msg, detail: detail, timestamp: Date()), at: 0)
            } catch {
                logs.insert(LogEntry(icon: "xmark.circle", message: "切换失败", detail: error.localizedDescription, timestamp: Date()), at: 0)
            }
            isSwitching = false
        }
    }
}
