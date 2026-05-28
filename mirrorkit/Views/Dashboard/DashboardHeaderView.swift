import SwiftUI

struct DashboardHeaderView: View {
    let lastMeasured: Date?
    let isMeasuring: Bool
    let onMeasure: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "gauge.medium")
                .font(.system(size: 18))
                .foregroundColor(.prismAccent)
            Text("Dashboard")
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)
            Spacer()
            if let last = lastMeasured {
                let interval = Date().timeIntervalSince(last)
                let text = interval < 60 ? "\(Int(interval))秒前" : "\(Int(interval / 60))分钟前"
                Text("上次测速: \(text)")
                    .font(.prismCaption)
                    .foregroundColor(.prismTextTertiary)
            }
            PrismButton(isMeasuring ? "测速中..." : "重新测速", systemImage: "arrow.clockwise", style: .secondary, isDisabled: isMeasuring, isLoading: isMeasuring, action: onMeasure)
                .focusEffectDisabled()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
