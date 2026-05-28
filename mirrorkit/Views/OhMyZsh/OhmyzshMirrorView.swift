import SwiftUI

struct OhmyzshMirrorView: View {
    @State private var vm = OhmyzshMirrorVM()

    @State private var showBanner = false
    @State private var bannerStyle: NotificationBanner.Style = .success
    @State private var bannerMessage = ""
    @State private var expandedLogIds: Set<UUID> = []

    var body: some View {
        Group {
            if vm.isInstalled {
                installedView
            } else {
                notInstalledView
            }
        }
        .background(Color.prismBackground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if vm.isInstalled { vm.startSpeedTest() }
        }
        .overlay(alignment: .top) {
            if showBanner {
                NotificationBanner(style: bannerStyle, message: bannerMessage, onDismiss: { showBanner = false })
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeOut(duration: 0.2), value: showBanner)
        .loadingOverlay(vm.isSwitching, message: "正在切换镜像源...")
        .onChange(of: vm.logs.count) { _, _ in
            if let lastLog = vm.logs.first {
                if lastLog.icon == "xmark.circle" {
                    showBannerMessage(style: .error, message: "切换失败")
                } else if lastLog.icon != "info.circle" {
                    showBannerMessage(style: .success, message: lastLog.message)
                }
            }
        }
    }

    private var notInstalledView: some View {
        EmptyState(
            systemImage: "terminal",
            title: "未检测到 oh-my-zsh",
            description: "Oh My Zsh 是一个管理 Zsh 配置的社区驱动框架。\n安装后即可在此管理镜像源，加速更新。",
            actionTitle: "了解如何安装",
            action: {
                if let url = URL(string: "https://ohmyz.sh") {
                    NSWorkspace.shared.open(url)
                }
            }
        )
    }

    private var installedView: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerArea
            Divider().overlay(Color.prismBorder)

            ScrollView {
                VStack(spacing: 20) {
                    ActiveOhmyzshCard(
                        mirror: vm.activeMirror,
                        latency: vm.latencyResults[vm.activeMirrorId],
                        isMeasuring: vm.isMeasuring
                    )

                    OhmyzshMirrorListView(
                        mirrors: vm.mirrors,
                        latencyResults: vm.latencyResults,
                        activeMirrorId: vm.activeMirrorId,
                        maxLatency: vm.maxLatency,
                        isMeasuring: vm.isMeasuring,
                        onSelect: { mirror in
                            vm.requestSwitch(to: mirror)
                        }
                    )

                    OperationLogView(
                        logs: vm.logs,
                        expandedLogIds: $expandedLogIds
                    )
                }
                .padding(20)
            }
        }
    }

    private var headerArea: some View {
        HStack {
            Text("Oh My Zsh 镜像设置")
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)
            Spacer()
            if let elapsed = vm.elapsedSinceLastMeasured {
                Text("上次测速: \(elapsed)")
                    .font(.prismCaption)
                    .foregroundColor(.prismTextTertiary)
            }
            PrismButton(vm.isMeasuring ? "测速中..." : "重新测速", systemImage: "arrow.clockwise", style: .secondary, isDisabled: vm.isMeasuring, isLoading: vm.isMeasuring, action: vm.startSpeedTest)
                .keyboardShortcut("r", modifiers: .command)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private func showBannerMessage(style: NotificationBanner.Style, message: String) {
        bannerStyle = style
        bannerMessage = message
        showBanner = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showBanner = false
        }
    }
}

#Preview {
    OhmyzshMirrorView()
        .frame(width: 700, height: 600)
}
