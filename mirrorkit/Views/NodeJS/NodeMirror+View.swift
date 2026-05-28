import SwiftUI

extension NodeMirror {
    @ViewBuilder
    func iconImage(size: CGFloat) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: size * 0.75))
            .foregroundColor(.prismAccent)
            .frame(width: size, height: size)
    }
}
