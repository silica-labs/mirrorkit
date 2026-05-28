# MirrorKit (镜箱) — Agent Guide

## CRITICAL: Never Auto-Commit

Do NOT commit any changes unless the user explicitly says "commit", "提交", or asks you to create a commit. Never commit proactively after completing a task — wait for the user's instruction. Violating this rule will be treated as a serious error.

## Git 提交规范

所有 commit 必须使用 emoji 前缀的 Conventional Commits 格式：`<emoji> <type>: <description>`

允许的 type：`feat`、`fix`、`refactor`、`chore`、`docs`、`style`、`perf`、`test`

Emoji 对照：
- ✨ `feat` — 新功能
- 🐛 `fix` — 修复 bug
- ♻️ `refactor` — 重构
- 🔧 `chore` — 杂项/构建
- 📝 `docs` — 文档
- 🎨 `style` — 代码风格
- ⚡️ `perf` — 性能优化
- ✅ `test` — 测试