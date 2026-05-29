import Cocoa

final class MenuBarManager: NSObject {
    private let statusItem: NSStatusItem
    private let menu = NSMenu()

    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        super.init()
        menu.delegate = self
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "point.3.filled.connected.trianglepath.dotted", accessibilityDescription: "MirrorKit")
        }
        rebuildMenu()
        statusItem.menu = menu
    }

    func rebuildMenu() {
        menu.removeAllItems()

        let header = NSMenuItem(title: "MirrorKit", action: nil, keyEquivalent: "")
        header.isEnabled = false
        menu.addItem(header)
        menu.addItem(.separator())

        addBrewMenu(to: menu)
        addOhmyzshMenu(to: menu)
        addGitHubMenu(to: menu)
        addNodeMenu(to: menu)
        addPypiMenu(to: menu)
        addGoMenu(to: menu)

        menu.addItem(.separator())
        let openItem = NSMenuItem(title: "打开 MirrorKit", action: #selector(openWindow), keyEquivalent: "o")
        openItem.target = self
        menu.addItem(openItem)
        let quitItem = NSMenuItem(title: "退出", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
    }

    private func addToolMenu(to menu: NSMenu, title: String, image: String, mirrors: [any Identifiable & Equatable], activeId: String, apply: @escaping (String) async throws -> Void) {
        let submenu = NSMenu()

        for mirror in mirrors {
            let mirrorTitle: String
            let mirrorId: String
            if let m = mirror as? BrewMirror { mirrorTitle = m.name; mirrorId = m.id }
            else if let m = mirror as? OhmyzshMirror { mirrorTitle = m.name; mirrorId = m.id }
            else if let m = mirror as? GitHubMirror { mirrorTitle = m.name; mirrorId = m.id }
            else if let m = mirror as? NodeMirror { mirrorTitle = m.name; mirrorId = m.id }
            else if let m = mirror as? PypiMirror { mirrorTitle = m.name; mirrorId = m.id }
            else if let m = mirror as? GoMirror { mirrorTitle = m.name; mirrorId = m.id }
            else { continue }

            let isActive = mirrorId == activeId
            let item = NSMenuItem(title: mirrorTitle, action: #selector(switchMirror(_:)), keyEquivalent: "")
            item.target = self
            item.state = isActive ? .on : .off
            item.representedObject = MirrorAction(apply: { try await apply(mirrorId) })
            if isActive {
                item.onStateImage = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
            }
            submenu.addItem(item)
        }

        let parent = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        parent.image = NSImage(systemSymbolName: image, accessibilityDescription: nil)
        parent.submenu = submenu
        menu.addItem(parent)
    }

    private func addBrewMenu(to menu: NSMenu) {
        let service = BrewMirrorService.shared
        addToolMenu(to: menu, title: "Homebrew", image: "mug", mirrors: BrewMirror.allPresets as [any Identifiable & Equatable], activeId: service.activeMirrorId, apply: { id in
            guard let mirror = BrewMirror.allPresets.first(where: { $0.id == id }) else { return }
            try await service.selectMirror(mirror)
        })
    }

    private func addOhmyzshMenu(to menu: NSMenu) {
        guard OhmyzshMirrorService.isInstalled() else { return }
        let service = OhmyzshMirrorService()
        addToolMenu(to: menu, title: "Oh My Zsh", image: "terminal", mirrors: OhmyzshMirror.allPresets as [any Identifiable & Equatable], activeId: service.activeMirrorId, apply: { id in
            guard let mirror = OhmyzshMirror.allPresets.first(where: { $0.id == id }) else { return }
            try await service.applyMirror(mirror)
        })
    }

    private func addGitHubMenu(to menu: NSMenu) {
        let service = GitHubMirrorService()
        addToolMenu(to: menu, title: "GitHub 镜像", image: "chevron.left.forwardslash.chevron.right", mirrors: GitHubMirror.allPresets as [any Identifiable & Equatable], activeId: service.activeMirrorId, apply: { id in
            guard let mirror = GitHubMirror.allPresets.first(where: { $0.id == id }) else { return }
            try await service.applyMirror(mirror)
        })
    }

    private func addNodeMenu(to menu: NSMenu) {
        let service = NodeMirrorService()
        addToolMenu(to: menu, title: "Node.js Release", image: "cube", mirrors: NodeMirror.allPresets as [any Identifiable & Equatable], activeId: service.activeMirrorId, apply: { id in
            guard let mirror = NodeMirror.allPresets.first(where: { $0.id == id }) else { return }
            try await service.applyMirror(mirror)
        })
    }

    private func addPypiMenu(to menu: NSMenu) {
        guard PypiMirrorService.isInstalled() else { return }
        let service = PypiMirrorService()
        addToolMenu(to: menu, title: "PyPI 镜像", image: "square.stack.3d.up", mirrors: PypiMirror.allPresets as [any Identifiable & Equatable], activeId: service.activeMirrorId, apply: { id in
            guard let mirror = PypiMirror.allPresets.first(where: { $0.id == id }) else { return }
            try await service.applyMirror(mirror)
        })
    }

    private func addGoMenu(to menu: NSMenu) {
        let service = GoMirrorService()
        addToolMenu(to: menu, title: "Go Module Proxy", image: "point.3.connected.trianglepath.dotted", mirrors: GoMirror.allPresets as [any Identifiable & Equatable], activeId: service.activeMirrorId, apply: { id in
            guard let mirror = GoMirror.allPresets.first(where: { $0.id == id }) else { return }
            try await service.applyMirror(mirror)
        })
    }

    @objc private func switchMirror(_ sender: NSMenuItem) {
        guard let action = sender.representedObject as? MirrorAction else { return }
        Task {
            do {
                try await action.apply()
                await MainActor.run { rebuildMenu() }
            } catch {
                await MainActor.run { rebuildMenu() }
            }
        }
    }

    @objc private func openWindow() {
        NSApp.activate(ignoringOtherApps: true)
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}

extension MenuBarManager: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        rebuildMenu()
    }
}

private struct MirrorAction {
    let apply: () async throws -> Void
}
