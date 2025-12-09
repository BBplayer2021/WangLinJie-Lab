# 网站部署指南 - fishandgoat.cloud

本指南将帮助您将网站部署到 **fishandgoat.cloud** 域名。

## 部署方案选择

- **GitHub Pages**（推荐 ⭐）：免费，自动 HTTPS，自动构建，支持自定义域名，使用 GitHub Actions
- **Netlify**：简单，免费，自动 HTTPS，适合快速部署
- **阿里云服务器**：完全控制，无流量限制，适合需要自定义配置
- **Vercel**：类似 Netlify，全球 CDN

## 方法一：使用 Netlify（推荐，最简单）

### 步骤 1：准备代码仓库

1. 将代码推送到 GitHub 仓库（如果还没有）
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/your-repo.git
   git push -u origin main
   ```

### 步骤 2：在 Netlify 部署

1. 访问 [Netlify](https://www.netlify.com/) 并注册/登录
2. 点击 "Add new site" → "Import an existing project"
3. 选择 GitHub 并授权，选择您的仓库
4. Netlify 会自动检测 `netlify.toml` 配置文件，使用 Jekyll 插件自动构建
   - 如果自动检测失败，手动配置：
     - **Build command**: `gem install bundler -v 2.4.22 && bundle install && bundle exec jekyll build`
     - **Publish directory**: `_site`
     - **Environment variables**: 
       - `JEKYLL_ENV=production`
       - `RUBY_VERSION=3.1`
5. 点击 "Deploy site"

**注意**：如果遇到 Bundler 版本问题，Netlify 会自动使用 Jekyll 插件处理。

### 步骤 3：配置自定义域名

1. 在 Netlify 站点设置中，进入 "Domain settings"
2. 点击 "Add custom domain"
3. 输入 `fishandgoat.cloud`
4. 按照 Netlify 的指示配置 DNS：
   - 添加 A 记录指向 Netlify 的 IP（Netlify 会提供）
   - 或添加 CNAME 记录指向 `your-site-name.netlify.app`

### 步骤 4：配置 HTTPS

Netlify 会自动为您的域名配置 SSL 证书（Let's Encrypt），通常几分钟内完成。

---

## 方法二：使用 Vercel

### 步骤 1：安装 Vercel CLI

```bash
npm i -g vercel
```

### 步骤 2：配置 Jekyll

创建 `vercel.json` 文件：

```json
{
  "buildCommand": "bundle exec jekyll build",
  "outputDirectory": "_site",
  "installCommand": "bundle install"
}
```

### 步骤 3：部署

```bash
vercel
```

### 步骤 4：配置域名

1. 在 Vercel 控制台，进入项目设置
2. 添加 `fishandgoat.cloud` 作为自定义域名
3. 按照指示配置 DNS 记录

---

## 方法三：使用 GitHub Pages（需要 GitHub Pro 或组织账户）

### 步骤 1：创建 GitHub 仓库

1. 在 GitHub 创建新仓库
2. 推送代码到仓库

### 步骤 2：配置 GitHub Pages

1. 在仓库设置中，进入 "Pages"
2. 选择 Source: "GitHub Actions"
3. 创建 `.github/workflows/jekyll.yml`：

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

### 步骤 3：配置自定义域名

1. 在仓库设置 → Pages → Custom domain
2. 输入 `fishandgoat.cloud`
3. 在域名注册商处配置 DNS：
   - 添加 CNAME 记录：`fishandgoat.cloud` → `your-username.github.io`
   - 或添加 A 记录指向 GitHub Pages IP

---

## 方法四：使用传统 VPS/服务器

### 步骤 1：构建网站

```bash
bundle exec jekyll build
```

### 步骤 2：上传文件

将 `_site` 目录中的所有文件上传到服务器。

### 步骤 3：配置 Web 服务器

#### Nginx 配置示例：

```nginx
server {
    listen 80;
    server_name fishandgoat.cloud www.fishandgoat.cloud;
    
    root /var/www/fishandgoat.cloud;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### 步骤 4：配置 SSL

使用 Let's Encrypt：

```bash
sudo certbot --nginx -d fishandgoat.cloud -d www.fishandgoat.cloud
```

---

## DNS 配置说明

无论使用哪种方法，都需要在域名注册商处配置 DNS：

### 如果使用 Netlify/Vercel：
- **CNAME 记录**：`fishandgoat.cloud` → `your-site.netlify.app` 或 `your-site.vercel.app`
- 或 **A 记录**：指向提供的 IP 地址

### 如果使用 GitHub Pages：
- **CNAME 记录**：`fishandgoat.cloud` → `your-username.github.io`
- 或 **A 记录**：指向 GitHub Pages 的 IP（185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153）

### 如果使用 VPS：
- **A 记录**：`fishandgoat.cloud` → 您的服务器 IP 地址

---

## 验证部署

部署完成后，访问以下地址验证：

1. **主域名**：https://fishandgoat.cloud
2. **检查 HTTPS**：确保网站使用 SSL 证书
3. **检查所有页面**：确保所有链接正常工作

---

## 常见问题

### 1. DNS 配置后无法访问
- 等待 DNS 传播（通常 24-48 小时，但通常更快）
- 使用 `nslookup fishandgoat.cloud` 检查 DNS 解析

### 2. HTTPS 证书问题
- 确保 DNS 已正确配置
- 等待 SSL 证书自动生成（通常几分钟到几小时）

### 3. 网站更新后未显示
- 清除浏览器缓存
- 检查构建日志是否有错误

---

## 推荐方案

**推荐使用 Netlify**，因为：
- ✅ 免费且易于使用
- ✅ 自动 HTTPS
- ✅ 自动构建和部署
- ✅ 全球 CDN
- ✅ 支持自定义域名

---

## 需要帮助？

如果遇到问题，请检查：
1. DNS 配置是否正确
2. 构建日志是否有错误
3. 域名是否已正确添加到托管平台

