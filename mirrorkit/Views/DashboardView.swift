import SwiftUI

struct DashboardView: View {
    @Binding var selectedItem: SidebarItem
    @State private var latency: TimeInterval?
    @State private var isMeasuring = false
    @State private var lastMeasured: Date?

    private let service = MirrorService.shared
    private let measurer = LatencyMeasurer()

    private var activeMirror: MirrorSource {
        MirrorSource.allPresets.first(where: { $0.id == service.activeMirrorId }) ?? MirrorSource.allPresets[0]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerArea
            Divider().overlay(Color.prismBorder)

            ScrollView {
                VStack(spacing: 20) {
                    activeMirrorCard
                }
                .padding(20)
            }
        }
        .background(Color.prismBackground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { measureActiveMirror() }
    }

    private var headerArea: some View {
        HStack {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 18))
                .foregroundColor(.prismAccent)
            Text("仪表盘")
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
            PrismButton(isMeasuring ? "测速中..." : "重新测速", systemImage: "arrow.clockwise", style: .secondary, isDisabled: isMeasuring, isLoading: isMeasuring, action: measureActiveMirror)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var activeMirrorCard: some View {
        let mirror = activeMirror

        return PrismCard(isSelected: true) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    mirror.iconImage(size: 32)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(mirror.name)
                                .font(.prismTitle)
                                .foregroundColor(.prismTextPrimary)
                            StatusIndicator(status: mirror.isOfficial ? .warning : .success)
                            Text("已生效")
                                .font(.prismCaption)
                                .foregroundColor(.prismTextSecondary)
                        }
                        HStack(spacing: 16) {
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
                            }
                            if let domain = mirror.bottleDomain {
                                HStack(spacing: 4) {
                                    Image(systemName: "link")
                                        .font(.system(size: 10))
                                    Text(domain)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }
                            }
                        }
                        .font(.prismCaption)
                        .foregroundColor(.prismTextTertiary)
                    }

                    Spacer()
                }

                Divider().overlay(Color.prismBorder)

                VStack(alignment: .leading, spacing: 6) {
                    configRow(label: "Brew Git Remote", value: mirror.brewGitRemote ?? "https://github.com/Homebrew/brew.git")
                    configRow(label: "BOTTLE_DOMAIN", value: mirror.bottleDomain ?? "（官方默认）")
                    configRow(label: "API_DOMAIN", value: mirror.apiDomain ?? "（官方默认）")
                }
                .font(.prismCaption)

                Divider().overlay(Color.prismBorder)

                HStack {
                    Spacer()
                    PrismButton("管理 Brew 镜像设置", systemImage: "chevron.right", style: .secondary) {
                        selectedItem = .brew
                    }
                    .focusEffectDisabled()
                }
            }
        }
    }

    private func configRow(label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .foregroundColor(.prismTextTertiary)
                .frame(width: 120, alignment: .trailing)
            Text(value)
                .foregroundColor(.prismTextSecondary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }

    private func measureActiveMirror() {
        guard !isMeasuring else { return }
        isMeasuring = true
        latency = nil

        Task {
            let result = await measurer.measure(url: activeMirror.testURL)
            latency = result
            isMeasuring = false
            lastMeasured = Date()
        }
    }
}

#Preview {
    DashboardView(selectedItem: .constant(.dashboard))
        .frame(width: 700, height: 500)
}
