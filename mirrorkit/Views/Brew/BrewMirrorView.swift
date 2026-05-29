import SwiftUI

struct BrewMirrorView: View {
    @State private var vm = BrewMirrorVM()

    @State private var showBanner = false
    @State private var bannerStyle: NotificationBanner.Style = .success
    @State private var bannerMessage = ""
    @State private var expandedLogIds: Set<UUID> = []
    @State private var showHelp = false

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

    private var installedView: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerArea

            ScrollView {
                VStack(spacing: 20) {
                    ActiveBrewCard(
                        mirror: vm.activeMirror,
                        latency: vm.latencyResults[vm.activeMirrorId],
                        isMeasuring: vm.isMeasuring
                    )

                    BrewMirrorListView(
                        mirrors: vm.mirrors,
                        latencyResults: vm.latencyResults,
                        activeMirrorId: vm.activeMirrorId,
                        maxLatency: vm.maxLatency,
                        isMeasuring: vm.isMeasuring,
                        onSelect: { mirror in
                            vm.confirmSwitch(to: mirror)
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

    private var notInstalledView: some View {
        EmptyState(
            systemImage: "mug",
            title: "未检测到 Homebrew",
            description: "Homebrew 是 macOS 上最流行的包管理器。\n安装后即可在此管理镜像源，加速 brew install。",
            actionTitle: "了解如何安装",
            action: {
                if let url = URL(string: "https://brew.sh") {
                    NSWorkspace.shared.open(url)
                }
            }
        )
    }

    private var headerArea: some View {
        HStack {
            Text("Brew 镜像设置")
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)

            Button(action: { showHelp = true }) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 14))
                    .foregroundColor(.prismTextTertiary)
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showHelp) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Homebrew 的安装和更新需要从 GitHub 下载 Formula 和二进制包，国内网络容易超时。切换到国内镜像源后，brew update 和 brew install 将从镜像站拉取，速度更快更稳定。")
                        .font(.prismBody)
                        .foregroundColor(.prismTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("• 切换后更新 ~/.zshrc 环境变量和 Homebrew 仓库 remote 地址")
                        Text("• 后续使用 brew update/install 即可享受加速")
                        Text("• 随时可以切回官方源，无任何副作用")
                    }
                    .font(.prismCaption)
                    .foregroundColor(.prismTextSecondary)
                }
                .padding(16)
                .frame(width: 360)
                .background(Color.prismSurface)
            }

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
    BrewMirrorView()
        .frame(width: 700, height: 600)
}
