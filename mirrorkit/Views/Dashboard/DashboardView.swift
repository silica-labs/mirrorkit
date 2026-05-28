import SwiftUI

struct DashboardView: View {
    @Binding var selectedItem: SidebarItem

    @State private var brewVM = BrewMirrorVM()
    @State private var gitHubVM = GitHubMirrorVM()
    @State private var nodeVM = NodeMirrorVM()
    @State private var pypiVM = PypiMirrorVM()

    @State private var brewLatency: TimeInterval?
    @State private var gitHubLatency: TimeInterval?
    @State private var nodeLatency: TimeInterval?
    @State private var pypiLatency: TimeInterval?
    @State private var isMeasuring = false
    @State private var lastMeasured: Date?

    private let measurer = LatencyMeasurer()

    private var activeBrew: BrewMirror { brewVM.activeMirror }
    private var activeGitHub: GitHubMirror { gitHubVM.activeMirror }
    private var activeNode: NodeMirror { nodeVM.activeMirror }
    private var activePypi: PypiMirror { pypiVM.activeMirror }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DashboardHeaderView(lastMeasured: lastMeasured, isMeasuring: isMeasuring, onMeasure: measureAll)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    brewCard
                    gitHubCard
                    nodeCard
                    pypiCard
                }
                .padding(20)
            }
        }
        .background(Color.prismBackground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { measureAll() }
    }

    private var brewCard: some View {
        let mirror = activeBrew
        return DashboardMirrorCard(
            icon: AnyView(mirror.iconImage(size: 24)),
            title: "Brew 镜像：\(mirror.name)",
            status: mirror.isOfficial ? .warning : .success,
            latency: brewLatency,
            isMeasuring: isMeasuring,
            destination: .brew,
            configContent: AnyView(
                VStack(alignment: .leading, spacing: 4) {
                    configRow("git remote", mirror.brewGitRemote ?? "https://github.com/Homebrew/brew.git")
                    configRow("BOTTLE_DOMAIN", mirror.bottleDomain ?? "（官方默认）")
                    configRow("API_DOMAIN", mirror.apiDomain ?? "（官方默认）")
                }
            ),
            onNavigate: { selectedItem = $0 }
        )
    }

    private var gitHubCard: some View {
        let mirror = activeGitHub
        return DashboardMirrorCard(
            icon: AnyView(mirror.iconImage(size: 24)),
            title: "GitHub 镜像：\(mirror.name)",
            status: mirror.isOfficial ? .warning : .success,
            latency: gitHubLatency,
            isMeasuring: isMeasuring,
            destination: .github,
            configContent: AnyView(
                VStack(alignment: .leading, spacing: 4) {
                    configRow("镜像 URL", mirror.mirrorURL ?? "（无）")
                    configRow("insteadOf", "https://github.com/")
                }
            ),
            onNavigate: { selectedItem = $0 }
        )
    }

    private var nodeCard: some View {
        let mirror = activeNode
        return DashboardMirrorCard(
            icon: AnyView(mirror.iconImage(size: 24)),
            title: "Node.js 镜像：\(mirror.name)",
            status: mirror.isOfficial ? .warning : .success,
            latency: nodeLatency,
            isMeasuring: isMeasuring,
            destination: .nodejs,
            configContent: AnyView(
                VStack(alignment: .leading, spacing: 4) {
                    configRow("NVM_NODEJS_ORG_MIRROR", mirror.mirrorURL ?? "（已清除）")
                    configRow("N_NODE_MIRROR", mirror.mirrorURL ?? "（已清除）")
                    configRow("FNM_NODE_DIST_MIRROR", mirror.mirrorURL ?? "（已清除）")
                }
            ),
            onNavigate: { selectedItem = $0 }
        )
    }

    private var pypiCard: some View {
        let mirror = activePypi
        return DashboardMirrorCard(
            icon: AnyView(mirror.iconImage(size: 24)),
            title: "PyPI 镜像：\(mirror.name)",
            status: mirror.isOfficial ? .warning : .success,
            latency: pypiLatency,
            isMeasuring: isMeasuring,
            destination: .pypi,
            configContent: AnyView(
                VStack(alignment: .leading, spacing: 4) {
                    configRow("index-url", mirror.mirrorURL ?? "（已清除）")
                    configRow("trusted-host", mirror.trustedHost ?? "（无）")
                }
            ),
            onNavigate: { selectedItem = $0 }
        )
    }

    private func configRow(_ label: String, _ value: String) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .foregroundColor(.prismTextTertiary)
                .lineLimit(1)
                .frame(width: 140, alignment: .trailing)
            Text(value)
                .foregroundColor(.prismTextSecondary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }

    private func measureAll() {
        guard !isMeasuring else { return }
        isMeasuring = true
        brewLatency = nil
        gitHubLatency = nil
        nodeLatency = nil
        pypiLatency = nil

        Task {
            async let brew = measurer.measure(url: activeBrew.testURL)
            async let gitHub = measurer.measure(url: activeGitHub.testURL, timeoutInterval: 10)
            async let node = measurer.measure(url: activeNode.testURL, timeoutInterval: 10)
            async let pypi = measurer.measure(url: activePypi.testURL, timeoutInterval: 10)

            let (b, g, n, p) = await (brew, gitHub, node, pypi)
            brewLatency = b
            gitHubLatency = g
            nodeLatency = n
            pypiLatency = p
            isMeasuring = false
            lastMeasured = Date()
        }
    }
}

#Preview {
    DashboardView(selectedItem: .constant(.dashboard))
        .frame(width: 700, height: 500)
}
