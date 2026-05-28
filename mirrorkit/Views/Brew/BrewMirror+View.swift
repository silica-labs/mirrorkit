import SwiftUI

extension BrewMirror {
    @ViewBuilder
    func iconImage(size: CGFloat) -> some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.75))
            .foregroundColor(.prismAccent)
            .frame(width: size, height: size)
    }
}
