import SwiftUI

struct StatusIndicator: View {
    enum Status: Equatable {
        case success, warning, error, unknown

        var color: Color {
            switch self {
            case .success: return .prismSuccess
            case .warning: return .prismWarning
            case .error: return .prismError
            case .unknown: return .prismTextTertiary
            }
        }
    }

    let status: Status
    var isPulsing: Bool = false

    @State private var pulseOpacity: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(status.color)
            .frame(width: 8, height: 8)
            .opacity(isPulsing ? pulseOpacity : 1.0)
            .onAppear {
                guard isPulsing else { return }
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    pulseOpacity = 0.4
                }
            }
    }
}

#Preview("Success") {
    HStack(spacing: 20) {
        StatusIndicator(status: .success)
        Text("正常").font(.prismBody)
    }
    .padding()
}

#Preview("Warning") {
    HStack(spacing: 20) {
        StatusIndicator(status: .warning)
        Text("警告").font(.prismBody)
    }
    .padding()
}

#Preview("Error") {
    HStack(spacing: 20) {
        StatusIndicator(status: .error)
        Text("错误").font(.prismBody)
    }
    .padding()
}

#Preview("Unknown") {
    HStack(spacing: 20) {
        StatusIndicator(status: .unknown)
        Text("未知").font(.prismBody)
    }
    .padding()
}

#Preview("Pulsing") {
    HStack(spacing: 20) {
        StatusIndicator(status: .error, isPulsing: true)
        Text("测速中...").font(.prismBody)
    }
    .padding()
}
