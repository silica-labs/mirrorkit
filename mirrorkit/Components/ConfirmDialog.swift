import SwiftUI

struct ConfirmDialog: View {
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let isDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @Binding var isPresented: Bool
    @State private var contentOpacity: CGFloat = 0

    init(
        title: String,
        message: String,
        confirmTitle: String = "确认",
        cancelTitle: String = "取消",
        isDestructive: Bool = false,
        isPresented: Binding<Bool>,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.isDestructive = isDestructive
        self._isPresented = isPresented
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    var body: some View {
        ZStack {
            Color.prismBackground.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text(title)
                        .font(.prismTitle)
                        .foregroundColor(.prismTextPrimary)

                    Text(message)
                        .font(.prismBody)
                        .foregroundColor(.prismTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                }
                .padding(24)

                Divider()
                    .overlay(Color.prismBorder)

                HStack(spacing: 0) {
                    Button(cancelTitle) {
                        dismiss()
                        onCancel()
                    }
                    .buttonStyle(.plain)
                    .font(.prismButton)
                    .foregroundColor(.prismTextPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)

                    Divider()
                        .overlay(Color.prismBorder)

                    Button(confirmTitle) {
                        dismiss()
                        onConfirm()
                    }
                    .buttonStyle(.plain)
                    .font(.prismButton)
                    .foregroundColor(isDestructive ? .prismError : .prismAccent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .frame(height: 44)
            }
            .frame(width: 280)
            .background(Color.prismSurface)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.prismBorder, lineWidth: 1)
            )
            .opacity(contentOpacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.2)) {
                    contentOpacity = 1
                }
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.15)) {
            contentOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            isPresented = false
        }
    }
}

struct ConfirmDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let isDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ConfirmDialog(
                        title: title,
                        message: message,
                        confirmTitle: confirmTitle,
                        cancelTitle: cancelTitle,
                        isDestructive: isDestructive,
                        isPresented: $isPresented,
                        onConfirm: onConfirm,
                        onCancel: onCancel
                    )
                }
            }
    }
}

extension View {
    func confirmDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "确认",
        cancelTitle: String = "取消",
        isDestructive: Bool = false,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void = {}
    ) -> some View {
        modifier(ConfirmDialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            cancelTitle: cancelTitle,
            isDestructive: isDestructive,
            onConfirm: onConfirm,
            onCancel: onCancel
        ))
    }
}

#Preview("Default") {
    Color.clear
        .frame(width: 400, height: 300)
        .confirmDialog(
            isPresented: .constant(true),
            title: "切换到官方源",
            message: "切换后将恢复 Homebrew 官方源配置。如果当前网络环境受限，可能导致 brew 操作变慢或失败。",
            onConfirm: {}
        )
}

#Preview("Destructive") {
    Color.clear
        .frame(width: 400, height: 300)
        .confirmDialog(
            isPresented: .constant(true),
            title: "删除快照",
            message: "此操作不可撤销，确定要删除这个快照吗？",
            confirmTitle: "删除",
            isDestructive: true,
            onConfirm: {}
        )
}
