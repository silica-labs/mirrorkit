import Foundation

enum SidebarItem: String, Hashable, CaseIterable {
    case dashboard
    case brew
    case github
    case npm
    case proxy
    case diagnostics

    var title: String {
        switch self {
        case .dashboard: return "仪表盘"
        case .brew: return "Brew 镜像"
        case .github: return "GitHub 镜像"
        case .npm: return "NPM 镜像"
        case .proxy: return "代理配置"
        case .diagnostics: return "诊断"
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard: return "gauge.medium"
        case .brew: return "mug"
        case .github: return "network"
        case .npm: return "cube"
        case .proxy: return "arrow.triangle.branch"
        case .diagnostics: return "stethoscope"
        }
    }
}

struct SidebarSection: Identifiable {
    let id: String
    let title: String
    let items: [SidebarItem]

    static let all: [SidebarSection] = [
        SidebarSection(id: "mirror", title: "镜像源", items: [.brew, .github, .npm]),
        SidebarSection(id: "network", title: "网络", items: [.proxy, .diagnostics]),
    ]
}
