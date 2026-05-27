import Foundation

final class LatencyMeasurer {
    func measure(url: String, timeoutInterval: TimeInterval = 5) async -> TimeInterval {
        guard let url = URL(string: url) else { return .infinity }
        let start = Date()
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = timeoutInterval
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...399).contains(httpResponse.statusCode)
            else { return .infinity }
            return Date().timeIntervalSince(start) * 1000
        } catch {
            return .infinity
        }
    }
}
