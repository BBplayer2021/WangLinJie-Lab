# Netlify 部署完整设置指南

## 问题诊断

如果 Netlify 日志只显示 "}" 或没有构建输出，通常是因为：
1. Netlify 没有正确识别 Jekyll 项目
2. 构建命令执行失败但没有输出错误
3. 需要使用 Netlify 的 Jekyll 插件

## 解决方案：参考文章配置（推荐）

根据 [参考文章](https://digitzh.github.io/posts/Jekyll+GitHub%E6%88%96Netlify%E6%90%AD%E5%BB%BA%E9%9D%99%E6%80%81%E7%BD%91%E7%AB%99/)，Netlify 部署 Jekyll 的配置如下：

**Build command**: `jekyll build`  
**Publish directory**: `_site`  
**Ruby version**: `3.3.5`（解决版本冲突问题）

### 方法 A：使用 netlify.toml 配置（已配置）

当前 `netlify.toml` 已按照参考文章配置：
- Build command: `jekyll build`
- Publish directory: `_site`
- Ruby version: `3.3.5`

确保在 Netlify UI 中：
1. **Site settings** → **Build & deploy** → **Build settings**
2. 开启 **"Use build settings from netlify.toml"**
3. 在 **Environment variables** 中添加 `RUBY_VERSION = 3.3.5`

### 方法 B：使用 Netlify Jekyll 插件（备用）

### 步骤 1：在 Netlify UI 中安装插件

**方法 A：通过 Plugins 页面（推荐）**
1. 登录 Netlify，进入您的站点
2. 进入 **Site settings** → **Plugins**（插件）
3. 点击 **"Add plugin"**（添加插件）或 **"Browse all plugins"**
4. 搜索 **"Jekyll"**
5. 找到 **"@netlify/plugin-jekyll"** 并点击 **"Install"**（安装）

**方法 B：通过 Build & deploy settings**
1. 登录 Netlify，进入您的站点
2. 进入 **Site settings** → **Build & deploy** → **Build settings**
3. 向下滚动找到 **"Build plugins"** 或 **"Plugins"** 部分
4. 点击 **"Add plugin"** 或 **"Install plugin"**
5. 搜索 **"Jekyll"** 并安装 **"@netlify/plugin-jekyll"**

**注意**：两种方法都可以，安装后插件会自动出现在两个地方。

### 步骤 2：配置构建设置（参考文章方法）

1. 进入 **Site settings** → **Build & deploy** → **Build settings**
2. 点击 **Edit settings**（编辑设置）

3. **重要**：按照参考文章配置以下设置：

   **Build command**（构建命令）：
   ```
   jekyll build
   ```
   （注意：参考文章使用的是 `jekyll build`，不是 `bundle exec jekyll build`）

   **Publish directory**（发布目录）：
   ```
   _site
   ```

4. 在 **Environment variables**（环境变量）中添加：
   - `JEKYLL_ENV` = `production`
   - `RUBY_VERSION` = `3.3.5`（**重要**：参考文章建议使用 3.3.5 解决版本冲突）

5. **关键设置**：
   - 确保 **"Use build settings from netlify.toml"** 选项是**开启**的
   - 这样会使用 `netlify.toml` 中的配置（已按参考文章配置）

6. 点击 **Save**（保存）

**提示**：参考文章提到，如果遇到 Ruby 版本冲突错误，设置 Ruby 版本为 3.3.5 即可解决。

### 步骤 3：清除缓存并重新部署

1. 返回站点概览
2. 点击 **Trigger deploy** → **Clear cache and deploy site**
3. 等待构建完成

## 如果插件方法不工作：手动构建命令

如果 Jekyll 插件不工作，使用以下手动配置：

### 在 Netlify UI 中设置：

**Build command**：
```bash
bundle config set --local path 'vendor/bundle' && bundle install && bundle exec jekyll build
```

**Publish directory**：
```
_site
```

**Environment variables**：
- `JEKYLL_ENV` = `production`
- `RUBY_VERSION` = `3.3`

## 验证配置

确保以下文件已提交到 GitHub：

- ✅ `Gemfile`
- ✅ `Gemfile.lock`
- ✅ `_config.yml`
- ✅ `netlify.toml`
- ✅ 所有 `.markdown` 文件
- ✅ `assets/` 目录

确保以下文件在 `.gitignore` 中（不应提交）：

- ✅ `_site/`（构建输出）
- ✅ `.sass-cache/`
- ✅ `.jekyll-cache/`

## 本地测试

在提交到 GitHub 之前，先在本地测试构建：

```bash
# 安装依赖
bundle install

# 构建网站
bundle exec jekyll build

# 检查 _site 目录是否生成
ls _site
```

如果本地构建成功，Netlify 也应该能成功构建。

## 常见问题

### 问题 1：日志只显示 "}"
**解决**：使用 Jekyll 插件，或确保构建命令正确

### 问题 2：Ruby 版本冲突
**错误信息**：`Bundler found conflicting requirements for the Ruby version`  
**解决**：根据参考文章，设置 `RUBY_VERSION=3.3.5` 即可解决。如果仍有问题，可以在 Gemfile 中添加：
```ruby
ruby '>= 3.1', '< 4.0'
```

### 问题 3：找不到 Gemfile
**解决**：确保 `Gemfile` 和 `Gemfile.lock` 已提交到仓库根目录

### 问题 4：构建超时
**解决**：使用 Ruby 3.3（Netlify 预装），避免编译 Ruby

## 获取完整日志

如果仍然失败，请：

1. 在 Netlify UI 中：
   - 进入 **Deploys** 标签
   - 点击失败的部署
   - 点击 **"Logs"** 或 **"Download deploy log"**
   - 复制完整的日志

2. 或者本地运行：
   ```bash
   git clone https://github.com/BBplayer2021/WangLinJie-Lab.git
   cd WangLinJie-Lab
   bundle install
   bundle exec jekyll build
   ```
   复制完整的终端输出

3. 将日志发送给我进行诊断

