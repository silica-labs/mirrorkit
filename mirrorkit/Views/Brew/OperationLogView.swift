import SwiftUI

struct OperationLogView: View {
    let logs: [LogEntry]
    @Binding var expandedLogIds: Set<UUID>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("操作日志")
                .font(.prismCaption)
                .foregroundColor(.prismTextTertiary)
                .textCase(.uppercase)

            if logs.isEmpty {
                HStack {
                    Spacer()
                    Text("暂无操作记录")
                        .font(.prismBody)
                        .foregroundColor(.prismTextTertiary)
                        .padding(.vertical, 24)
                    Spacer()
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(logs) { log in
                        logRow(log)
                    }
                }
                .background(Color.prismSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.prismBorder, lineWidth: 1)
                )
                .cornerRadius(6)
            }
        }
    }

    private func logRow(_ log: LogEntry) -> some View {
        let isExpanded = expandedLogIds.contains(log.id)

        return VStack(spacing: 0) {
            Button(action: {
                if log.detail != nil {
                    if isExpanded {
                        expandedLogIds.remove(log.id)
                    } else {
                        expandedLogIds.insert(log.id)
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: log.icon)
                        .font(.system(size: 11))
                        .foregroundColor(logIconColor(log.icon))

                    Text(formattedTime(log.timestamp))
                        .font(.prismCaption)
                        .foregroundColor(.prismTextTertiary)

                    Text(log.message)
                        .font(.prismBody)
                        .foregroundColor(.prismTextPrimary)

                    if log.detail != nil {
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9))
                            .foregroundColor(.prismTextTertiary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(.easeOut(duration: 0.2), value: isExpanded)
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded, let detail = log.detail {
                Text(detail)
                    .font(.prismCaption)
                    .foregroundColor(.prismTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private func logIconColor(_ icon: String) -> Color {
        switch icon {
        case "checkmark.circle": return .prismSuccess
        case "xmark.circle": return .prismError
        case "globe": return .prismAccentWarm
        default: return .prismAccent
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f.string(from: date)
    }
}
