import SwiftUI

struct GoMirrorView: View {
    @State private var vm = GoMirrorVM()

    @State private var showBanner = false
    @State private var bannerStyle: NotificationBanner.Style = .success
    @State private var bannerMessage = ""
    @State private var expandedLogIds: Set<UUID> = []
    @State private var showHelp = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerArea

            ScrollView {
                VStack(spacing: 20) {
                    ActiveGoCard(
                        mirror: vm.activeMirror,
                        latency: vm.latencyResults[vm.activeMirrorId],
                        isMeasuring: vm.isMeasuring
                    )

                    GoMirrorListView(
                        mirrors: vm.mirrors,
                        latencyResults: vm.latencyResults,
                        activeMirrorId: vm.activeMirrorId,
                        maxLatency: vm.maxLatency,
                        isMeasuring: vm.isMeasuring,
                        onSelect: { vm.requestSwitch(to: $0) }
                    )

                    OperationLogView(
                        logs: vm.logs,
                        expandedLogIds: $expandedLogIds
                    )
                }
                .padding(20)
            }
        }
        .background(Color.prismBackground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { vm.startSpeedTest() }
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

    private var headerArea: some View {
        HStack {
            Text("Go Module Proxy")
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
                    Text("Go 模块代理（GOPROXY）是 Go 语言的模块下载中间层。默认的 proxy.golang.org 在国内访问缓慢，切换到国内镜像源后，go get / go mod download 速度将大幅提升。")
                        .font(.prismBody)
                        .foregroundColor(.prismTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("• 切换后设置 GOPROXY 环境变量到 shell profile")
                        Text("• 后续使用 go get / go mod download 即可享受加速")
                        Text("• 不依赖 Go 安装，写入环境变量本身无副作用")
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
                .focusEffectDisabled()
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
    GoMirrorView()
        .frame(width: 700, height: 600)
}
