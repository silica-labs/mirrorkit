import SwiftUI

struct DashboardMirrorCard: View {
    let icon: AnyView
    let title: String
    let status: StatusIndicator.Status
    let latency: TimeInterval?
    let isMeasuring: Bool
    let destination: SidebarItem
    let configContent: AnyView
    let onNavigate: (SidebarItem) -> Void

    var body: some View {
        PrismCard(isSelected: true) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 10) {
                    icon
                    Text(title)
                        .font(.prismTitle)
                        .foregroundColor(.prismTextPrimary)
                        .lineLimit(1)
                    Spacer()
                    StatusIndicator(status: status)
                }
                .padding(.bottom, 10)

                Divider().overlay(Color.prismBorder)

                configContent
                    .font(.prismCaption)
                    .padding(.vertical, 10)

                Spacer(minLength: 0)

                Divider().overlay(Color.prismBorder)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    if let latency = latency, latency.isFinite {
                        Text("\(Int(latency))ms")
                            .foregroundColor(.prismTextSecondary)
                    } else if isMeasuring {
                        Text("测速中...")
                            .foregroundColor(.prismTextTertiary)
                    } else {
                        Text("--")
                            .foregroundColor(.prismTextTertiary)
                    }
                    Spacer()
                    PrismButton(systemImage: "gearshape", style: .icon) {
                        onNavigate(destination)
                    }
                    .focusEffectDisabled()
                }
                .font(.prismCaption)
                .padding(.top, 10)
            }
            .frame(maxHeight: .infinity)
        }
    }
}
