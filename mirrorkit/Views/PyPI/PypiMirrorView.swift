import SwiftUI

struct PypiMirrorView: View {
    @State private var vm = PypiMirrorVM()

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
                    ActivePypiCard(
                        mirror: vm.activeMirror,
                        latency: vm.latencyResults[vm.activeMirrorId],
                        isMeasuring: vm.isMeasuring
                    )

                    PypiMirrorListView(
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
                } else {
                    showBannerMessage(style: .success, message: lastLog.message)
                }
            }
        }
    }

    private var headerArea: some View {
        HStack {
            Text("PyPI 设置")
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
                    Text("Python 包管理器 pip 默认从 PyPI 官方源下载包，国内网络容易超时。切换到国内镜像源后，pip install 速度将大幅提升。")
                        .font(.prismBody)
                        .foregroundColor(.prismTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("• 切换后更新 pip 全局配置文件")
                        Text("• 后续使用 pip install 即可享受加速")
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
    PypiMirrorView()
        .frame(width: 700, height: 600)
}
