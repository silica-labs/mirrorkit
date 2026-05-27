import SwiftUI

struct DashboardPlaceholder: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.prismAccent)

            Text("MirrorKit")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.prismTextPrimary)

            Text("面向中国开发者的本地开发网络环境治理工具")
                .font(.prismBody)
                .foregroundColor(.prismTextSecondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.prismBackground)
    }
}

#Preview("Dashboard Placeholder") {
    DashboardPlaceholder()
        .frame(width: 500, height: 400)
}
