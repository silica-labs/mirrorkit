import SwiftUI

struct LatencyBar: View {
    let latency: TimeInterval?
    let maxLatency: TimeInterval
    let isMeasuring: Bool

    private let barHeight: CGFloat = 8
    private let cornerRadius: CGFloat = 4

    private var fillRatio: CGFloat {
        guard let latency = latency, latency.isFinite, maxLatency > 0 else { return 0 }
        return min(1.0, CGFloat(latency / maxLatency))
    }

    private var barColor: Color {
        guard let latency = latency, latency.isFinite else { return .prismTextTertiary }
        if latency < 50 { return Color(hex: "#00F0FF") }
        if latency < 150 { return Color(hex: "#007AFF") }
        return Color(hex: "#F87171")
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.prismBorder)
                    .frame(height: barHeight)

                if isMeasuring {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.prismAccent)
                        .frame(width: geo.size.width, height: barHeight)
                        .opacity(0.3)
                } else if let latency = latency, latency.isFinite {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(barColor)
                        .frame(width: geo.size.width * fillRatio, height: barHeight)
                        .animation(.easeOut(duration: 0.4), value: fillRatio)
                }
            }
        }
        .frame(height: barHeight)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview("Latency Bars") {
    VStack(spacing: 16) {
        LatencyBar(latency: 32, maxLatency: 200, isMeasuring: false)
        LatencyBar(latency: 89, maxLatency: 200, isMeasuring: false)
        LatencyBar(latency: 150, maxLatency: 200, isMeasuring: false)
        LatencyBar(latency: nil, maxLatency: 200, isMeasuring: false)
        LatencyBar(latency: nil, maxLatency: 200, isMeasuring: true)
    }
    .padding()
    .frame(width: 300)
}
