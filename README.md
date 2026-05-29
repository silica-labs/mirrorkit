# MirrorKit (镜箱)

一款 macOS 原生工具，一键管理开发工具的镜像源，解决国内网络环境的慢速下载与超时问题。

## 功能

- **一键切换** — 内置主流镜像源列表（清华、中科大、阿里云等），点选即可切换
- **实时测速** — 自动检测各镜像延迟，数据可视化呈现
- **安全可控** — 所有修改在本地完成，随时一键恢复官方源
- **原生 macOS** — 纯 SwiftUI 构建，Prism 设计系统，支持深色/浅色主题

## 支持的工具

| 工具 | 镜像源数 | 切换方式 |
|------|---------|---------|
| Homebrew | 6 | 环境变量 + git remote |
| Oh My Zsh | 6 | git remote set-url |
| GitHub | 4 | git insteadOf |
| Node.js | 10 | 环境变量 |
| PyPI | 11 | pip config |

## 安装

- **DMG 下载** — 从 [Releases](https://github.com/anomalyco/mirrorkit/releases) 下载最新版本
- **Homebrew Cask** — `brew install --cask mirrorkit`（即将支持）

## 技术栈

SwiftUI · macOS Sequoia+ · MVVM · Prism Design System

项目架构：View 层 → ViewModel (`@Observable`) → Service 层（shell 命令、文件读写）

## 项目结构

```
mirrorkit/
├── mirrorkitApp.swift          # 入口
├── ContentView.swift           # NavigationSplitView
├── Models/                     # 镜像数据模型
├── ViewModels/                 # 可观察状态
├── Services/                   # 业务逻辑（命令执行、配置读写）
├── Components/                 # 可复用 UI 组件
├── Views/                      # 各工具页面
└── Design/                     # Prism 设计系统
```

## 开发要求

- Xcode 26+
- macOS Sequoia 26.4+

打开 `mirrorkit.xcodeproj` 直接 Build 即可。
