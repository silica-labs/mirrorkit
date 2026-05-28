import SwiftUI

struct NodeMirrorView: View {
    @State private var vm = NodeMirrorVM()

    @State private var showBanner = false
    @State private var bannerStyle: NotificationBanner.Style = .success
    @State private var bannerMessage = ""
    @State private var expandedLogIds: Set<UUID> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerArea
            Divider().overlay(Color.prismBorder)

            ScrollView {
                VStack(spacing: 20) {
                    ActiveNodeMirrorCard(
                        mirror: vm.activeMirror,
                        latency: vm.latencyResults[vm.activeMirrorId],
                        isMeasuring: vm.isMeasuring
                    )

                    NodeMirrorListView(
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
            Text("Node.js 镜像设置")
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
    NodeMirrorView()
        .frame(width: 700, height: 600)
}
