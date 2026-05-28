import SwiftUI

struct PypiMirrorListView: View {
    let mirrors: [PypiMirror]
    let latencyResults: [String: TimeInterval]
    let activeMirrorId: String
    let maxLatency: TimeInterval
    let isMeasuring: Bool
    let onSelect: (PypiMirror) -> Void

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

    private func mirrorRow(_ mirror: PypiMirror) -> some View {
        let isActive = mirror.id == activeMirrorId
        let latency = latencyResults[mirror.id]
        let isUnreachable = !mirror.isOfficial && latency == .infinity

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
                    .frame(width: 140, alignment: .leading)
                    .lineLimit(1)

                HStack(spacing: 2) {
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
                            .frame(width: 56, alignment: .trailing)
                    } else if isMeasuring {
                        Text("--")
                            .font(.prismMonoSmall)
                            .foregroundColor(.prismTextTertiary)
                            .frame(width: 56, alignment: .trailing)
                    }

                    if let latency = latency, latency.isFinite {
                        LatencyBar(latency: latency, maxLatency: maxLatency, isMeasuring: isMeasuring)
                            .frame(width: 80)
                    } else if isUnreachable {
                        LatencyBar(latency: .infinity, maxLatency: maxLatency, isMeasuring: isMeasuring)
                            .frame(width: 80)
                    } else {
                        LatencyBar(latency: -1, maxLatency: maxLatency, isMeasuring: isMeasuring)
                            .frame(width: 80)
                    }
                }
                .frame(width: 140, alignment: .trailing)

                Spacer()

                if isActive {
                    Text("当前")
                        .font(.prismCaption)
                        .foregroundColor(.prismAccent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.prismAccent.opacity(0.1))
                        .cornerRadius(4)
                } else if isUnreachable {
                    Text("无法访问")
                        .font(.prismCaption)
                        .foregroundColor(.prismError)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.prismError.opacity(0.1))
                        .cornerRadius(4)
                }

                if mirror.isRecommended && !isActive {
                    Text("推荐")
                        .font(.prismCaption)
                        .foregroundColor(.prismSuccess)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.prismSuccess.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isActive ? Color.prismAccentDim : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isUnreachable)
        .focusEffectDisabled()
    }
}
