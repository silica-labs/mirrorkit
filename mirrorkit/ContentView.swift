import SwiftUI

struct ContentView: View {
    @State private var selectedItem: SidebarItem = .dashboard
    @AppStorage("mirrorkit.colorScheme") private var colorScheme: ColorSchemeOption = .system

    var body: some View {
        NavigationSplitView {
            SidebarView(selectedItem: $selectedItem)
        } detail: {
            detailView
        }
        .navigationSplitViewStyle(.prominentDetail)
        .toolbar(.hidden)
        .toolbarBackground(.hidden)
        .ignoresSafeArea(edges: .top)
        .preferredColorScheme(colorScheme == .system ? nil : (colorScheme == .dark ? .dark : .light))
    }

    @ViewBuilder
    private var detailView: some View {
        switch selectedItem {
        case .dashboard:
            DashboardView(selectedItem: $selectedItem)
        case .brew:
            BrewMirrorView()
        case .github:
            GitHubMirrorView()
        case .nodejs:
            NodeMirrorView()
        default:
            placeholder(for: selectedItem)
        }
    }

    private func placeholder(for item: SidebarItem) -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: item.systemImage)
                .font(.system(size: 36))
                .foregroundColor(.prismTextTertiary)
            Text(item.title)
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)
            Text("正在开发中")
                .font(.prismBody)
                .foregroundColor(.prismTextTertiary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.prismBackground)
    }
}

#Preview {
    ContentView()
        .frame(width: 800, height: 500)
}
