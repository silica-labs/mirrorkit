import SwiftUI
import Combine

struct PrismButton: View {
    enum Style {
        case primary, secondary, text, icon
    }

    let title: String?
    let systemImage: String?
    let style: Style
    let action: () -> Void
    var isDisabled: Bool = false
    var isLoading: Bool = false

    @State private var isPressed = false
    @State private var angle: Double = 0
    @State private var timer: AnyCancellable?

    init(
        _ title: String? = nil,
        systemImage: String? = nil,
        style: Style = .primary,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: {
            guard !isDisabled, !isLoading else { return }
            withAnimation(.easeOut(duration: 0.15)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
            action()
        }) {
            HStack(spacing: 6) {
                if isLoading {
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            style == .primary || style == .icon ? Color.white : Color.prismAccent,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                        )
                        .rotationEffect(.degrees(angle))
                        .frame(width: 13, height: 13)
                        .onAppear {
                            angle = 0
                            timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect().sink { _ in
                                angle = (angle + 7.5).truncatingRemainder(dividingBy: 360)
                            }
                        }
                        .onDisappear {
                            timer?.cancel()
                            timer = nil
                        }
                } else if let image = systemImage {
                    Image(systemName: image)
                        .font(.system(size: style == .icon ? 16 : 13))
                }
                if let title = title, style != .icon {
                    Text(title)
                        .font(.prismButton)
                }
            }
            .frame(minWidth: style == .icon ? 28 : 0)
            .padding(.horizontal, style == .icon ? 6 : (style == .text ? 8 : 16))
            .padding(.vertical, style == .icon ? 6 : 8)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: style == .icon ? 4 : 6)
                    .stroke(borderColor, lineWidth: style == .secondary ? 1 : 0)
            )
            .cornerRadius(style == .icon ? 4 : 6)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isDisabled ? 0.6 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isPressed)
        .animation(.easeOut(duration: 0.15), value: isDisabled)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            Color.prismAccent
        case .secondary, .text, .icon:
            Color.clear
        }
    }

    private var foregroundColor: Color {
        if isDisabled { return .prismTextTertiary }
        switch style {
        case .primary:
            return .prismBackground
        case .secondary:
            return .prismTextPrimary
        case .text:
            return .prismAccent
        case .icon:
            return .prismTextSecondary
        }
    }

    private var borderColor: Color {
        if isDisabled { return .prismBorder }
        switch style {
        case .secondary:
            return .prismBorder
        default:
            return .clear
        }
    }
}

#Preview("Primary") {
    PrismButton("切换镜像", systemImage: "arrow.triangle.swap", action: {})
        .padding()
}

#Preview("Secondary") {
    PrismButton("重新测速", style: .secondary, action: {})
        .padding()
}

#Preview("Text") {
    PrismButton("查看详情", style: .text, action: {})
        .padding()
}

#Preview("Icon") {
    PrismButton(systemImage: "gearshape", style: .icon, action: {})
        .padding()
}

#Preview("Loading") {
    PrismButton("保存", isLoading: true, action: {})
        .padding()
}

#Preview("Disabled") {
    PrismButton("切换镜像", isDisabled: true, action: {})
        .padding()
}

#Preview("Button Group") {
    HStack(spacing: 12) {
        PrismButton("主按钮", action: {})
        PrismButton("次按钮", style: .secondary, action: {})
    }
    .padding()
}
