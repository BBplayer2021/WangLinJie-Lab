# GitHub Pages 部署指南

## 重要说明

GitHub Pages 有一些限制：
- 只支持特定的 Jekyll 插件
- 使用 `github-pages` gem（包含特定版本的 Jekyll）
- 某些主题可能不兼容
- 免费账户只能使用公共仓库

## 方案选择

### 方案一：使用 GitHub Actions 构建（推荐 ⭐⭐⭐⭐⭐）

**优点**：
- ✅ 可以使用最新版本的 Jekyll
- ✅ 可以使用任何 Jekyll 主题和插件
- ✅ 完全控制构建过程
- ✅ 支持自定义域名和 HTTPS

### 方案二：使用 GitHub Pages 原生 Jekyll（有限制）

**限制**：
- ❌ 只能使用 GitHub Pages 支持的插件
- ❌ 主题可能不兼容
- ❌ Jekyll 版本固定

## 方案一：使用 GitHub Actions（推荐）

### 步骤 1：创建 GitHub Actions 工作流

创建文件：`.github/workflows/jekyll.yml`

```yaml
name: Jekyll site CI

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.1'
          bundler-cache: true
      - name: Setup Jekyll
        run: bundle install
      - name: Build with Jekyll
        run: bundle exec jekyll build
      - name: Setup Pages
        uses: actions/configure-pages@v4
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./_site
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 步骤 2：启用 GitHub Pages

1. 在 GitHub 仓库中，进入 **Settings** → **Pages**
2. 在 **Source** 部分，选择 **"GitHub Actions"**
3. 保存设置

### 步骤 3：配置自定义域名

1. 在仓库根目录创建 `CNAME` 文件：
   ```
   fishandgoat.cloud
   ```

2. 在 GitHub Pages 设置中配置自定义域名：
   - **Settings** → **Pages** → **Custom domain**
   - 输入 `fishandgoat.cloud`
   - 勾选 **"Enforce HTTPS"**

3. 配置 DNS：
   - 添加 CNAME 记录：`fishandgoat.cloud` → `your-username.github.io`
   - 或添加 A 记录指向 GitHub Pages IP：
     - 185.199.108.153
     - 185.199.109.153
     - 185.199.110.153
     - 185.199.111.153

### 步骤 4：推送代码

```bash
# 添加所有文件
git add .

# 提交
git commit -m "Configure for GitHub Pages deployment"

# 推送到 GitHub
git push origin main
```

GitHub Actions 会自动构建并部署网站。

## 方案二：使用 GitHub Pages 原生 Jekyll（如果主题兼容）

### 步骤 1：修改 Gemfile

```ruby
source "https://rubygems.org"

# 使用 github-pages gem（包含 Jekyll 和所有支持的插件）
gem "github-pages", group: :jekyll_plugins

# 如果主题支持，可以保留
# gem "academic-pages", "~> 2.5"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-seo-tag"
end
```

### 步骤 2：更新 _config.yml

确保插件在 GitHub Pages 支持列表中：
- ✅ jekyll-feed
- ✅ jekyll-seo-tag
- ❌ 某些自定义插件可能不支持

### 步骤 3：启用 GitHub Pages

1. **Settings** → **Pages**
2. 选择 **Source**: `main` 分支，`/ (root)` 目录
3. 保存

### 步骤 4：配置自定义域名

创建 `CNAME` 文件（同上）

## 当前主题兼容性

**注意**：`academic-pages` 主题可能不完全兼容 GitHub Pages 原生构建。

**建议**：
- 使用 **方案一（GitHub Actions）**，这样可以继续使用当前主题
- 或者切换到 GitHub Pages 支持的主题（如 minima、minima、jekyll-theme-chirpy 等）

## 推荐配置（GitHub Actions）

### 创建 GitHub Actions 工作流文件

我已经为您创建了工作流文件，只需：

1. 确保代码已推送到 GitHub
2. 在 GitHub 仓库中启用 Pages（使用 GitHub Actions）
3. 配置自定义域名

### 更新 Gemfile（可选）

如果使用 GitHub Actions，可以保持当前的 Gemfile 不变。

## 验证部署

部署完成后，访问：
- https://your-username.github.io/WangLinJie-Lab/（如果使用子目录）
- https://fishandgoat.cloud（配置自定义域名后）

## 更新网站

每次推送代码到 `main` 分支，GitHub Actions 会自动：
1. 构建 Jekyll 网站
2. 部署到 GitHub Pages
3. 更新网站内容

## 优势

使用 GitHub Pages 的优势：
- ✅ 完全免费
- ✅ 自动 HTTPS
- ✅ 自动构建和部署
- ✅ 版本控制集成
- ✅ 支持自定义域名
- ✅ 全球 CDN

## 注意事项

1. **仓库必须是公开的**（免费账户）
2. **构建时间限制**：每次构建最多 10 分钟
3. **存储限制**：1GB
4. **带宽限制**：每月 100GB

## 故障排查

### 构建失败

1. 检查 GitHub Actions 日志：**Actions** 标签
2. 确保 `Gemfile` 和 `Gemfile.lock` 已提交
3. 检查 Jekyll 构建错误

### 自定义域名不工作

1. 确保 `CNAME` 文件已提交
2. 检查 DNS 配置是否正确
3. 等待 DNS 传播（最多 48 小时）

### 样式丢失

1. 检查 `baseurl` 配置
2. 确保资源路径正确
3. 检查主题是否兼容

---

**推荐使用方案一（GitHub Actions）**，这样可以继续使用当前的主题和配置。

