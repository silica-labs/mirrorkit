import SwiftUI

struct SidebarView: View {
    @Binding var selectedItem: SidebarItem
    @AppStorage("mirrorkit.colorScheme") private var colorScheme: ColorSchemeOption = .system

    var body: some View {
        VStack(spacing: 0) {
            logoArea
            Rectangle().fill(Color.prismBorder).frame(height: 1)
            menuList
            Rectangle().fill(Color.prismBorder).frame(height: 1)
            bottomBar
        }
        .frame(width: 220)
        .navigationSplitViewColumnWidth(min: 220, ideal: 220, max: 220)
        .background(Color.prismBackground)
    }

    private var logoArea: some View {
        HStack(spacing: 10) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.prismAccent)
            Text("MirrorKit")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.prismTextPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var menuList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                menuRow(.dashboard)

                ForEach(SidebarSection.all) { section in
                    Text(section.title)
                        .font(.prismCaption)
                        .foregroundColor(.prismTextTertiary)
                        .textCase(.uppercase)
                        .padding(.leading, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 4)

                    ForEach(section.items, id: \.self) { item in
                        menuRow(item)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func menuRow(_ item: SidebarItem) -> some View {
        let isSelected = selectedItem == item
        return Button(action: { selectedItem = item }) {
            HStack(spacing: 10) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(isSelected ? .prismAccent : .prismTextPrimary)
                    .frame(width: 20, alignment: .center)
                Text(item.title)
                    .font(.prismBody)
                    .foregroundColor(isSelected ? .prismAccent : .prismTextPrimary)
            }
            .padding(.leading, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
                .background(isSelected ? Color.prismAccentDim : Color.clear)
                .overlay(
                    Rectangle()
                        .fill(isSelected ? Color.prismAccent : Color.clear)
                        .frame(width: 3),
                    alignment: .leading
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }

    private var bottomBar: some View {
        HStack(spacing: 4) {
            themeButton
            Spacer()
            // settingsButton
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.prismSurface)
    }

    private var themeButton: some View {
        PrismButton(systemImage: colorScheme.systemImage, style: .icon) {
            withAnimation(.easeOut(duration: 0.15)) {
                colorScheme = colorScheme.next()
            }
        }
        .focusEffectDisabled()
    }

    // private var settingsButton: some View {
    //     PrismButton(systemImage: "gearshape", style: .icon, action: {})
    //         .focusEffectDisabled()
    // }
}

enum ColorSchemeOption: String, CaseIterable {
    case dark, light, system

    var label: String {
        switch self {
        case .dark: return "暗色"
        case .light: return "亮色"
        case .system: return "自动"
        }
    }

    var systemImage: String {
        switch self {
        case .dark: return "moon"
        case .light: return "sun.max"
        case .system: return "circle.lefthalf.filled"
        }
    }

    func next() -> ColorSchemeOption {
        switch self {
        case .dark: return .light
        case .light: return .system
        case .system: return .dark
        }
    }
}

#Preview("Sidebar") {
    SidebarView(selectedItem: .constant(.dashboard))
        .frame(width: 220, height: 500)
}
