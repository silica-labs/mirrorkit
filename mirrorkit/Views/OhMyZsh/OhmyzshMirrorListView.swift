import SwiftUI

struct OhmyzshMirrorListView: View {
    let mirrors: [OhmyzshMirror]
    let latencyResults: [String: TimeInterval]
    let activeMirrorId: String
    let maxLatency: TimeInterval
    let isMeasuring: Bool
    let onSelect: (OhmyzshMirror) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(mirrors) { mirror in
                mirrorRow(mirror)
                if mirror.id != mirrors.last?.id {
                    Divider().overlay(Color.prismBorder)
                }
            }
        }
        .background(Color.prismSurface)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.prismBorder, lineWidth: 1)
        )
        .cornerRadius(8)
    }

    private func mirrorRow(_ mirror: OhmyzshMirror) -> some View {
        let isActive = mirror.id == activeMirrorId
        let latency = latencyResults[mirror.id]
        let isUnreachable = mirror.id != "official" && latency == .infinity

        return Button(action: {
            guard !isActive, !isUnreachable else { return }
            onSelect(mirror)
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isActive ? Color.prismAccent : Color.prismTextTertiary, lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                    if isActive {
                        Circle()
                            .fill(Color.prismAccent)
                            .frame(width: 8, height: 8)
                    }
                }

                mirror.iconImage(size: 18)

                Text(mirror.name)
                    .font(.prismBody)
                    .foregroundColor(.prismTextPrimary)
                    .frame(width: 120, alignment: .leading)

                if let latency = latency, latency.isFinite {
                    Text("\(Int(latency))ms")
                        .font(.prismMonoSmall)
                        .foregroundColor(.prismTextSecondary)
                        .lineLimit(1)
                        .frame(width: 56, alignment: .trailing)
                } else if isUnreachable {
                    Text("超时")
                        .font(.prismMonoSmall)
                        .foregroundColor(.prismError)
                        .lineLimit(1)
                        .frame(width: 56, alignment: .trailing)
                } else {
                    Text("--")
                        .font(.prismMonoSmall)
                        .foregroundColor(.prismTextTertiary)
                        .lineLimit(1)
                        .frame(width: 56, alignment: .trailing)
                }

                LatencyBar(latency: latency, maxLatency: maxLatency, isMeasuring: isMeasuring && latency == nil)
                    .frame(width: 120)

                if mirror.isRecommended {
                    Text("推荐")
                        .font(.prismCaption)
                        .foregroundColor(.prismAccentWarm)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.prismAccentWarm.opacity(0.15))
                        .cornerRadius(3)
                }

                if isUnreachable {
                    Text("无法访问")
                        .font(.prismCaption)
                        .foregroundColor(.prismError)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.prismError.opacity(0.1))
                        .cornerRadius(3)
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(isActive ? Color.prismAccentDim : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isUnreachable)
    }
}
