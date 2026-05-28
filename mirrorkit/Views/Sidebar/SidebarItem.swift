import Foundation

enum SidebarItem: String, Hashable, CaseIterable {
    case dashboard
    case brew
    case ohmyzsh
    case github
    case nodejs
    case pypi
    case proxy
    case diagnostics

    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .brew: return "Brew 镜像"
        case .ohmyzsh: return "Oh My Zsh 镜像"
        case .github: return "GitHub 镜像"
        case .nodejs: return "Node.js 镜像"
        case .pypi: return "PyPI 镜像"
        case .proxy: return "代理配置"
        case .diagnostics: return "诊断"
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard: return "gauge.medium"
        case .brew: return "mug"
        case .ohmyzsh: return "terminal"
        case .github: return "chevron.left.forwardslash.chevron.right"
        case .nodejs: return "cube"
        case .pypi: return "square.stack.3d.up"
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
        SidebarSection(id: "mirror", title: "镜像源", items: [.brew, .ohmyzsh, .github, .nodejs, .pypi]),
        // SidebarSection(id: "network", title: "网络", items: [.proxy, .diagnostics]),
    ]
}
