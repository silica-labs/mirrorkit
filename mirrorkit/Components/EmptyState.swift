import SwiftUI

struct EmptyState: View {
    let systemImage: String
    let title: String
    let description: String?
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        systemImage: String,
        title: String,
        description: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundColor(.prismTextTertiary)

            Text(title)
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)

            if let description = description {
                Text(description)
                    .font(.prismBody)
                    .foregroundColor(.prismTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }

            if let actionTitle = actionTitle, let action = action {
                PrismButton(actionTitle, style: .primary, action: action)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
    }
}

#Preview("No Snapshots") {
    EmptyState(
        systemImage: "tray",
        title: "暂无快照",
        description: "配置好镜像源后可以创建快照，方便后续恢复或迁移。",
        actionTitle: "创建快照",
        action: {}
    )
    .frame(width: 320, height: 300)
}

#Preview("No Items") {
    EmptyState(
        systemImage: "magnifyingglass",
        title: "没有找到结果",
        description: "尝试其他关键词或调整筛选条件。"
    )
    .frame(width: 320, height: 300)
}
