# Refactoring TODOs

## 高优先级

### 1. 引入 `MirrorProtocol` 协议抽象

`MirrorSource`/`GitHubMirror`/`NodeMirror` 共享 `id`/`name`/`testURL`/`isOfficial` + 图标属性，但没有统一协议。导致：
- 3 套几乎相同的 View（ActiveCard、ListView、MainView）无法泛型化
- `iconImage(size:)` 需要 3 份相同实现（属性名 `icon` vs `systemImage` 还不一致）
- 预估节省 ~400 行

```swift
protocol MirrorItem: Identifiable {
    var id: String { get }
    var name: String { get }
    var testURL: String { get }
    var isOfficial: Bool { get }
    var systemImage: String { get }
}
```

### 2. 合并 3 个 ViewModel 基类/协议

`BrewMirrorVM`/`GitHubMirrorVM`/`NodeMirrorVM` ~75% 属性/方法重复：
- `mirrors`、`latencyResults`、`isMeasuring`、`isSwitching`、`lastMeasured`、`logs`
- `maxLatency`、`activeMirror`、`elapsedSinceLastMeasured`
- `startSpeedTest()`、`requestSwitch()`/`confirmSwitch()`/`cancelSwitch()`

### 3. 统一 ActiveMirrorCard 组件

`ActiveMirrorCard`/`ActiveGitHubCard`/`ActiveNodeMirrorCard` ~70% 结构重复（布局、时钟显示、分隔线、configRow）。

### 4. 统一 MirrorListView 组件

`MirrorListView`/`GitHubMirrorListView`/`NodeMirrorListView` ~90% 结构重复（圆形选择按钮、图标、名称、延迟、LatencyBar、徽章逻辑）。

### 5. 统一 MainView（页面级视图）

`BrewMirrorView`/`GitHubMirrorView`/`NodeMirrorView` ~80% 重复（headerArea、ScrollView、banner、loadingOverlay、onAppear、showBannerMessage）。

---

## 中优先级

### 6. Dashboard 使用 3 个 VM（已完成）

- 已改为注入 `BrewMirrorVM`/`GitHubMirrorVM`/`NodeMirrorVM` 而非直接创建 Service
- 测速仍保持轻量级（3 URL 而非 21 个）

### 7. Service 层一致性

- `MirrorService` 是 `@MainActor` 单例
- `GitHubMirrorService` / `NodeMirrorService` 是普通 class 且非单例
- 多实例时 UserDefaults 读写一致，但需要确认是否有预期外的状态丢失

### 8. `configRow` label 宽度不统一

- `ActiveMirrorCard`: 120pt, `ActiveGitHubCard`: 120pt, `ActiveNodeMirrorCard`: 160pt, `DashboardView`: 140pt
- 应统一或动态计算

### 9. 确认弹窗不一致

- Brew/GitHub: 两步确认（`requestSwitch` → `confirmSwitch`/`cancelSwitch` + confirmDialog）
- Node.js: 直接切换（无确认弹窗）

### 10. `Managers/` 目录只有 1 个文件

`GitRemoteManager` 孤悬在 `Managers/`，可合并到 `Services/`。

### 11. `MirrorEnvironmentBuilder` 过于简单

只有一个静态方法，可内联到 `ShellConfigService` 或 `ShellProfileManager`。

### 12. UserDefaults 访问层级不统一

- Brew → `MirrorPreferenceStore`（Infrastructure 层）
- GitHub → GitHubMirrorService 直接访问
- Node.js → NodeMirrorService 直接访问

### 13. `OperationLogView` expandedLogIds 重复

三个 MainView 各自声明 `@State private var expandedLogIds: Set<UUID> = []`，应提取到 VM 或共享。

### 14. `LatencyMeasurer` timeout 无明确理由

Brew 5s，GitHub/Node.js 10s，Dashboard 各自指定但无注释或抽象。

---

## 低优先级

### 15. PrismButton 加载动画

使用 `Timer.publish` + `AnyCancellable` + 手动角度计算，建议改用 `ProgressView` 或 `TimelineView` + `.linear` 动画。
