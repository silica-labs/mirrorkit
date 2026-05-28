import SwiftUI

struct ActiveNodeMirrorCard: View {
    let mirror: NodeMirror
    let latency: TimeInterval?
    let isMeasuring: Bool

    var body: some View {
        PrismCard(isSelected: true) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    mirror.iconImage(size: 32)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(mirror.name)
                                .font(.prismTitle)
                                .foregroundColor(.prismTextPrimary)
                            StatusIndicator(status: mirror.isOfficial ? .warning : .success)
                            Text("已生效")
                                .font(.prismCaption)
                                .foregroundColor(.prismTextSecondary)
                        }
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10))
                                if let latency = latency, latency.isFinite {
                                    Text("\(Int(latency))ms")
                                        .foregroundColor(.prismTextSecondary)
                                } else if isMeasuring {
                                    Text("测速中...")
                                        .foregroundColor(.prismTextTertiary)
                                } else {
                                    Text("--")
                                        .foregroundColor(.prismTextTertiary)
                                }
                            }
                            if let url = mirror.mirrorURL {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.up.right.square")
                                        .font(.system(size: 10))
                                    Text(url)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }
                                .foregroundColor(.prismAccent)
                                .onTapGesture {
                                    if let url = URL(string: url) {
                                        NSWorkspace.shared.open(url)
                                    }
                                }
                                .onHover { isHovered in
                                    if isHovered {
                                        NSCursor.pointingHand.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                            }
                        }
                        .font(.prismCaption)
                        .foregroundColor(.prismTextTertiary)
                    }

                    Spacer()
                }

                Divider().overlay(Color.prismBorder)

                VStack(alignment: .leading, spacing: 6) {
                    configRow(label: "NVM_NODEJS_ORG_MIRROR", value: mirror.mirrorURL ?? "（已清除）")
                    configRow(label: "N_NODE_MIRROR", value: mirror.mirrorURL ?? "（已清除）")
                    configRow(label: "FNM_NODE_DIST_MIRROR", value: mirror.mirrorURL ?? "（已清除）")
                }
                .font(.prismCaption)
            }
        }
    }

    private func configRow(label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .foregroundColor(.prismTextTertiary)
                .frame(width: 160, alignment: .trailing)
            Text(value)
                .foregroundColor(.prismTextSecondary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}
