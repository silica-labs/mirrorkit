import SwiftUI

struct LoadingOverlay: View {
    let message: String?

    init(_ message: String? = nil) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
                .progressViewStyle(CircularProgressViewStyle(tint: .prismAccent))
                .frame(width: 24, height: 24)

            if let message = message {
                Text(message)
                    .font(.prismBody)
                    .foregroundColor(.prismTextSecondary)
            }
        }
        .padding(24)
        .background(Color.prismSurface)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.prismBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 16)
    }
}

struct LoadingOverlayModifier: ViewModifier {
    let isLoading: Bool
    let message: String?

    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    Color.prismBackground.opacity(0.6)
                        .ignoresSafeArea()

                    LoadingOverlay(message)
                }
            }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool, message: String? = nil) -> some View {
        modifier(LoadingOverlayModifier(isLoading: isLoading, message: message))
    }
}

#Preview("With Message") {
    Color.clear
        .frame(width: 300, height: 200)
        .loadingOverlay(true, message: "正在测速...")
}

#Preview("Without Message") {
    Color.clear
        .frame(width: 300, height: 200)
        .loadingOverlay(true)
}
