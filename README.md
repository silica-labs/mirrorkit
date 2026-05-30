# MirrorKit (镜箱)

一款 macOS 原生工具，一键管理开发工具的镜像源，解决国内网络环境的慢速下载与超时问题。

## 功能

- **一键切换** — 内置主流镜像源列表（清华、中科大、阿里云等），点选即可切换
- **实时测速** — 自动检测各镜像延迟，数据可视化呈现
- **菜单栏快速切换** — 无需打开应用，从 Mac 顶部菜单栏直接切换镜像源
- **Dashboard 总览** — 所有工具状态、延迟一览
- **安全可控** — 所有修改在本地完成，随时一键恢复官方源
- **原生 macOS** — 纯 SwiftUI 构建，Prism 设计系统，支持深色/浅色主题

## 支持的工具

| 工具 | 镜像源数 | 切换方式 |
|------|---------|---------|
| Homebrew | 6 | 环境变量 + git remote |
| Oh My Zsh | 6 | git remote set-url |
| GitHub | 4 | git insteadOf |
| Node.js Release | 10 | 环境变量 |
| PyPI | 11 | pip config |
| Go Module Proxy | 6 | 环境变量 |

## 安装

- **DMG 下载** — 从 [Releases](https://github.com/silica-labs/mirrorkit/releases) 下载最新版本
- **Homebrew Cask** — `brew install --cask mirrorkit`

## 技术栈

SwiftUI · macOS Sequoia+ · MVVM · Prism Design System

项目架构：View 层 → ViewModel (`@Observable`) → Service 层（shell 命令、文件读写）

## 项目结构

```
mirrorkit/
├── mirrorkitApp.swift          # 入口 + NSStatusBar 菜单
├── MenuBarManager.swift        # 菜单栏快速切换
├── ContentView.swift           # NavigationSplitView
├── Models/                     # 镜像数据模型
├── ViewModels/                 # 可观察状态
├── Services/                   # 业务逻辑（命令执行、配置读写）
├── Components/                 # 可复用 UI 组件
├── Views/                      # 各工具页面
│   ├── Dashboard/              # 总览面板
│   ├── Sidebar/                # 侧边栏
│   ├── Brew/                   # Homebrew 镜像
│   ├── OhMyZsh/                # Oh My Zsh 镜像
│   ├── GitHub/                 # GitHub 镜像
│   ├── NodeJS/                 # Node.js Release 镜像
│   ├── PyPI/                   # PyPI 镜像
│   └── Go/                     # Go Module Proxy 镜像
├── Infrastructure/             # ShellProfileManager, CommandExecutor
└── Design/                     # Prism 设计系统
```

## 开发要求

- Xcode 26+
- macOS Sequoia 15.6+

打开 `mirrorkit.xcodeproj` 直接 Build 即可。
