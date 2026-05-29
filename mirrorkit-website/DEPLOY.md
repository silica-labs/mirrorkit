# 官网部署指南

## 平台选择

推荐使用 **Cloudflare Pages**，免费额度足够个人项目使用。

## 前置条件

- GitHub 仓库已推送 `mirrorkit-website/` 目录
- 一个自定义域名（可选，不绑定也能用 `<project>.pages.dev` 访问）

## 部署步骤

### 1. 登录 Cloudflare Dashboard

打开 https://dash.cloudflare.com ，进入 **Workers & Pages**。

### 2. 创建 Pages 项目

点击 **Create** → **Pages** → **Connect to Git**。

### 3. 授权 GitHub

选择 `silica-labs/mirrorkit` 仓库。

### 4. 配置构建

| 字段 | 值 |
|------|-----|
| Project name | `mirrorkit` |
| Production branch | `main` |
| Build command | （留空，纯静态） |
| Build output directory | `mirrorkit-website` |
| Root directory | （留空） |

点击 **Save and Deploy**。等待约 1 分钟，首次部署完成。

### 5. 绑定自定义域名（可选）

在 Pages 项目 → **Custom domains** → **Set up a custom domain**。

输入域名（如 `mirrorkit.dev`），Cloudflare 会自动添加 DNS 记录并颁发 SSL 证书。

### 6. 后续更新

推送到 `main` 分支后，Cloudflare Pages 会自动检测 `mirrorkit-website/` 目录的变更并重新部署，无需手动操作。

## 验证

部署完成后访问：
- 默认域名：`https://mirrorkit.pages.dev`
- 自定义域名：`https://你的域名`
