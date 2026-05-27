import SwiftUI

struct Toast: View {
    enum Style {
        case success, warning, error

        var color: Color {
            switch self {
            case .success: return .prismSuccess
            case .warning: return .prismWarning
            case .error: return .prismError
            }
        }

        var systemImage: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            }
        }
    }

    let style: Style
    let message: String
    let duration: TimeInterval

    @Binding var isPresented: Bool
    @State private var offset: CGFloat = -80
    @State private var opacity: CGFloat = 0

    init(
        style: Style,
        message: String,
        duration: TimeInterval = 2.5,
        isPresented: Binding<Bool>
    ) {
        self.style = style
        self.message = message
        self.duration = duration
        self._isPresented = isPresented
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: style.systemImage)
                .font(.system(size: 14))
                .foregroundColor(style.color)

            Text(message)
                .font(.prismBody)
                .foregroundColor(.prismTextPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.prismSurface)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.prismBorder, lineWidth: 1)
        )
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.15), radius: 8)
        .offset(y: offset)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(dampingFraction: 0.8)) {
                offset = 0
                opacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation(.easeOut(duration: 0.2)) {
                    offset = -80
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    isPresented = false
                }
            }
        }
    }
}

struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let style: Toast.Style
    let message: String
    let duration: TimeInterval

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isPresented {
                    Toast(
                        style: style,
                        message: message,
                        duration: duration,
                        isPresented: $isPresented
                    )
                    .padding(.top, 16)
                    .transition(.identity)
                }
            }
    }
}

extension View {
    func toast(
        isPresented: Binding<Bool>,
        style: Toast.Style,
        message: String,
        duration: TimeInterval = 2.5
    ) -> some View {
        modifier(ToastViewModifier(
            isPresented: isPresented,
            style: style,
            message: message,
            duration: duration
        ))
    }
}

#Preview("Success") {
    Color.clear
        .frame(width: 400, height: 200)
        .toast(isPresented: .constant(true), style: .success, message: "已成功切换到清华大学镜像源")
}

#Preview("Error") {
    Color.clear
        .frame(width: 400, height: 200)
        .toast(isPresented: .constant(true), style: .error, message: "切换失败，已自动回滚")
}
