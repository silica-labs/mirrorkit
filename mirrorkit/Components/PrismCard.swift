import SwiftUI

struct PrismCard<Content: View>: View {
    let isSelected: Bool
    let action: (() -> Void)?
    @ViewBuilder let content: Content

    @State private var isHovering = false

    init(
        isSelected: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.isSelected = isSelected
        self.action = action
        self.content = content()
    }

    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    cardContent
                }
                .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }

    private var cardContent: some View {
        content
            .padding(16)
            .background(Color.prismSurface)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.prismAccent.opacity(isSelected ? 0.25 : 0), lineWidth: isSelected ? 1 : 0)
                    .blur(radius: 4)
            )
            .cornerRadius(8)
    }

    private var borderColor: Color {
        if isSelected { return .prismAccent }
        if isHovering { return .prismBorderHover }
        return .prismBorder
    }
}

#Preview("Default") {
    PrismCard {
        VStack(alignment: .leading, spacing: 8) {
            Text("清华大学 TUNA")
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)
            HStack(spacing: 6) {
                Circle().fill(Color.prismSuccess).frame(width: 8, height: 8)
                Text("延迟: 32ms")
                    .font(.prismBody)
                    .foregroundColor(.prismTextSecondary)
            }
        }
    }
    .padding()
}

#Preview("Selected") {
    PrismCard(isSelected: true) {
        VStack(alignment: .leading, spacing: 8) {
            Text("清华大学 TUNA")
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)
            HStack(spacing: 6) {
                Circle().fill(Color.prismSuccess).frame(width: 8, height: 8)
                Text("延迟: 32ms")
                    .font(.prismBody)
                    .foregroundColor(.prismTextSecondary)
            }
        }
    }
    .padding()
}

#Preview("With Action") {
    PrismCard(action: { print("tapped") }) {
        VStack(alignment: .leading, spacing: 8) {
            Text("清华大学 TUNA")
                .font(.prismTitle)
                .foregroundColor(.prismTextPrimary)
            Text("点击选择此镜像源")
                .font(.prismCaption)
                .foregroundColor(.prismTextTertiary)
        }
    }
    .padding()
}
