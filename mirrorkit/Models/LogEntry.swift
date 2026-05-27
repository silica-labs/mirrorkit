import Foundation

struct LogEntry: Identifiable {
    let id = UUID()
    let icon: String
    let message: String
    let detail: String?
    let timestamp: Date

    init(icon: String, message: String, detail: String? = nil, timestamp: Date) {
        self.icon = icon
        self.message = message
        self.detail = detail
        self.timestamp = timestamp
    }
}
