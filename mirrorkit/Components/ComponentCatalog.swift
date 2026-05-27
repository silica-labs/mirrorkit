import SwiftUI

struct ComponentCatalog: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Buttons") {
                    NavigationLink("PrismButton") { PrismButtonDemo() }
                }
                Section("Containers") {
                    NavigationLink("PrismCard") { PrismCardDemo() }
                }
                Section("Feedback") {
                    NavigationLink("StatusIndicator") { StatusIndicatorDemo() }
                    NavigationLink("NotificationBanner") { NotificationBannerDemo() }
                    NavigationLink("Toast") { ToastDemo() }
                    NavigationLink("ConfirmDialog") { ConfirmDialogDemo() }
                    NavigationLink("LoadingOverlay") { LoadingOverlayDemo() }
                }
                Section("Placeholder") {
                    NavigationLink("EmptyState") { EmptyStateDemo() }
                }
            }
            .navigationTitle("Prism 组件库")
        }
    }
}

// MARK: - PrismButton Demo

struct PrismButtonDemo: View {
    var body: some View {
        VStack(spacing: 24) {
            ComponentGroup("变体") {
                PrismButton("主按钮", action: {})
                PrismButton("次按钮", style: .secondary, action: {})
                PrismButton("文字按钮", style: .text, action: {})
                PrismButton(systemImage: "gearshape", style: .icon, action: {})
            }
            ComponentGroup("带图标") {
                PrismButton("切换镜像", systemImage: "arrow.triangle.swap", action: {})
                PrismButton("刷新", systemImage: "arrow.clockwise", style: .secondary, action: {})
            }
            ComponentGroup("状态") {
                PrismButton("加载中", isLoading: true, action: {})
                PrismButton("已禁用", isDisabled: true, action: {})
            }
            ComponentGroup("横向排列") {
                HStack(spacing: 12) {
                    PrismButton("确定", action: {})
                    PrismButton("取消", style: .secondary, action: {})
                }
            }
        }
        .padding(24)
        .navigationTitle("PrismButton")
    }
}

// MARK: - PrismCard Demo

struct PrismCardDemo: View {
    @State private var selected = false

    var body: some View {
        VStack(spacing: 24) {
            ComponentGroup("默认卡片") {
                PrismCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("清华大学 TUNA")
                            .font(.prismTitle)
                            .foregroundColor(.prismTextPrimary)
                        Text("延迟: 32ms")
                            .font(.prismBody)
                            .foregroundColor(.prismTextSecondary)
                    }
                }
            }
            ComponentGroup("选中态") {
                PrismCard(isSelected: selected, action: { selected.toggle() }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("点击切换选中态")
                            .font(.prismTitle)
                            .foregroundColor(.prismTextPrimary)
                        Text(selected ? "已选中 (冷光青边框)" : "未选中")
                            .font(.prismBody)
                            .foregroundColor(.prismTextSecondary)
                    }
                }
            }
            ComponentGroup("带操作") {
                PrismCard(action: { print("tap") }) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "shippingbox")
                                .foregroundColor(.prismAccent)
                            Text("中科大 USTC")
                                .font(.prismTitle)
                                .foregroundColor(.prismTextPrimary)
                        }
                        Text("点击选择此镜像源")
                            .font(.prismCaption)
                            .foregroundColor(.prismTextTertiary)
                    }
                }
            }
        }
        .padding(24)
        .navigationTitle("PrismCard")
    }
}

// MARK: - StatusIndicator Demo

struct StatusIndicatorDemo: View {
    var body: some View {
        VStack(spacing: 20) {
            ComponentGroup("四种状态") {
                LabelItem { StatusIndicator(status: .success) } label: { Text("Success — #34D399 / #10B981") }
                LabelItem { StatusIndicator(status: .warning) } label: { Text("Warning — #FBBF24 / #D97706") }
                LabelItem { StatusIndicator(status: .error) } label: { Text("Error — #F87171 / #DC2626") }
                LabelItem { StatusIndicator(status: .unknown) } label: { Text("Unknown — #5A5A6E / #9A9AB0") }
            }
            ComponentGroup("脉冲动画") {
                LabelItem { StatusIndicator(status: .error, isPulsing: true) } label: { Text("测速中脉冲 (800ms)") }
            }
        }
        .padding(24)
        .navigationTitle("StatusIndicator")
    }
}

// MARK: - NotificationBanner Demo

struct NotificationBannerDemo: View {
    var body: some View {
        VStack(spacing: 16) {
            ComponentGroup("四种样式") {
                NotificationBanner(style: .info, message: "信息：环境变量已写入 ~/.zshrc", onDismiss: {})
                NotificationBanner(style: .success, message: "成功：已切换到清华大学镜像源", onDismiss: {})
                NotificationBanner(style: .warning, message: "警告：当前镜像版本已滞后 7 天", onDismiss: {})
                NotificationBanner(style: .error, message: "错误：切换失败，已自动回滚", onDismiss: {})
            }
        }
        .padding(24)
        .navigationTitle("NotificationBanner")
    }
}

// MARK: - Toast Demo

struct ToastDemo: View {
    @State private var showSuccess = false
    @State private var showError = false

    var body: some View {
        VStack(spacing: 16) {
            ComponentGroup("触发演示") {
                PrismButton("显示成功 Toast", action: { showSuccess = true })
                PrismButton("显示错误 Toast", style: .secondary, action: { showError = true })
            }
        }
        .padding(24)
        .navigationTitle("Toast")
        .toast(isPresented: $showSuccess, style: .success, message: "已成功切换到清华大学镜像源")
        .toast(isPresented: $showError, style: .error, message: "切换失败，已自动回滚")
    }
}

// MARK: - ConfirmDialog Demo

struct ConfirmDialogDemo: View {
    @State private var showDefault = false
    @State private var showDestructive = false

    var body: some View {
        VStack(spacing: 16) {
            ComponentGroup("触发演示") {
                PrismButton("弹出确认框", action: { showDefault = true })
                PrismButton("弹出删除确认", style: .secondary, action: { showDestructive = true })
            }
        }
        .padding(24)
        .navigationTitle("ConfirmDialog")
        .confirmDialog(
            isPresented: $showDefault,
            title: "切换到官方源",
            message: "切换后将恢复 Homebrew 官方源配置。如果当前网络环境受限，可能导致 brew 操作变慢或失败。",
            onConfirm: { showDefault = false }
        )
        .confirmDialog(
            isPresented: $showDestructive,
            title: "删除快照",
            message: "此操作不可撤销，确定要删除这个快照吗？",
            confirmTitle: "删除",
            isDestructive: true,
            onConfirm: { showDestructive = false }
        )
    }
}

// MARK: - LoadingOverlay Demo

struct LoadingOverlayDemo: View {
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 16) {
            ComponentGroup("触发演示") {
                PrismButton("开始加载", action: { isLoading = true })
                PrismButton("停止加载", style: .secondary, action: { isLoading = false })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .navigationTitle("LoadingOverlay")
        .loadingOverlay(isLoading, message: "正在测速...")
    }
}

// MARK: - EmptyState Demo

struct EmptyStateDemo: View {
    var body: some View {
        VStack(spacing: 32) {
            ComponentGroup("无快照") {
                EmptyState(
                    systemImage: "tray",
                    title: "暂无快照",
                    description: "配置好镜像源后可以创建快照，方便后续恢复或迁移。",
                    actionTitle: "创建快照",
                    action: {}
                )
                .frame(height: 220)
                .background(Color.prismBackground)
                .cornerRadius(8)
            }
            ComponentGroup("无搜索结果") {
                EmptyState(
                    systemImage: "magnifyingglass",
                    title: "没有找到结果",
                    description: "尝试其他关键词或调整筛选条件。"
                )
                .frame(height: 200)
                .background(Color.prismBackground)
                .cornerRadius(8)
            }
        }
        .padding(24)
        .navigationTitle("EmptyState")
    }
}

// MARK: - Shared Helpers

struct ComponentGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.prismCaption)
                .foregroundColor(.prismTextTertiary)
                .textCase(.uppercase)
                .padding(.bottom, 4)

            content
        }
    }
}

struct LabelItem<LabelContent: View>: View {
    let indicator: StatusIndicator
    let label: LabelContent

    init(
        @ViewBuilder indicator: () -> StatusIndicator,
        @ViewBuilder label: () -> LabelContent
    ) {
        self.indicator = indicator()
        self.label = label()
    }

    var body: some View {
        HStack(spacing: 12) {
            indicator
            label
                .font(.prismBody)
                .foregroundColor(.prismTextPrimary)
        }
    }
}

#Preview("ComponentCatalog") {
    ComponentCatalog()
        .preferredColorScheme(.dark)
}
