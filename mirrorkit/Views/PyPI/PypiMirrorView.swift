import SwiftUI

struct PypiMirrorView: View {
    @State private var vm = PypiMirrorVM()

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
        .overlay(
            NotificationBanner(style: bannerStyle, message: bannerMessage, onDismiss: { showBanner = false })
                .padding(.horizontal, 20)
                .padding(.top, 8),
            alignment: .top
        )
        .animation(.easeOut(duration: 0.2), value: showBanner)
        .loadingOverlay(vm.isSwitching, message: "正在切换镜像源...")
        .onChange(of: vm.logs.count) { _, _ in
            if let last = vm.logs.first {
                bannerStyle = last.icon == "xmark.circle" ? .error : .success
                bannerMessage = last.message
                showBanner = true
                Task {
                    try? await Task.sleep(nanoseconds: 2_500_000_000)
                    showBanner = false
                }
            }
        }
    }

    private var headerArea: some View {
        HStack {
            Image(systemName: "gear.badge.questionmark")
                .font(.system(size: 18))
                .foregroundColor(.prismAccent)
            Text("PyPI 镜像")
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)
            Spacer()
            if let elapsed = vm.elapsedSinceLastMeasured {
                Text("上次测速: \(elapsed)")
                    .font(.prismCaption)
                    .foregroundColor(.prismTextTertiary)
            }
            PrismButton(vm.isMeasuring ? "测速中..." : "重新测速", systemImage: "arrow.clockwise", style: .secondary, isDisabled: vm.isMeasuring, isLoading: vm.isMeasuring, action: vm.startSpeedTest)
                .focusEffectDisabled()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview {
    PypiMirrorView()
        .frame(width: 700, height: 600)
}
