import SwiftUI

struct NotificationBanner: View {
    enum Style {
        case success, warning, error, info

        var color: Color {
            switch self {
            case .success: return .prismSuccess
            case .warning: return .prismWarning
            case .error: return .prismError
            case .info: return .prismAccent
            }
        }

        var systemImage: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }

    let style: Style
    let message: String
    let onDismiss: (() -> Void)?

    @State private var isShowing = true

    init(
        style: Style,
        message: String,
        onDismiss: (() -> Void)? = nil
    ) {
        self.style = style
        self.message = message
        self.onDismiss = onDismiss
    }

    var body: some View {
        if isShowing {
            HStack(spacing: 8) {
                Image(systemName: style.systemImage)
                    .font(.system(size: 14))
                    .foregroundColor(style.color)

                Text(message)
                    .font(.prismBody)
                    .foregroundColor(.prismTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let onDismiss = onDismiss {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.15)) {
                            isShowing = false
                        }
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.prismTextTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(style.color.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style.color.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(6)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
}

#Preview("Info") {
    NotificationBanner(
        style: .info,
        message: "环境变量已写入 ~/.zshrc，打开新终端后生效。",
        onDismiss: {}
    )
    .padding()
}

#Preview("Success") {
    NotificationBanner(
        style: .success,
        message: "已成功切换到清华大学镜像源",
        onDismiss: {}
    )
    .padding()
}

#Preview("Warning") {
    NotificationBanner(
        style: .warning,
        message: "当前镜像版本已滞后 7 天，建议切换至其他镜像源。",
        onDismiss: {}
    )
    .padding()
}

#Preview("Error") {
    NotificationBanner(
        style: .error,
        message: "切换失败，已自动回滚至之前的配置。",
        onDismiss: {}
    )
    .padding()
}
