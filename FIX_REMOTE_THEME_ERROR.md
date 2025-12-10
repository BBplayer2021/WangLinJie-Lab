# 修复 remote_theme 构建错误

## 错误原因

使用 `remote_theme: academic-pages/academic-pages.github.io` 需要 `jekyll-remote-theme` 插件，但 `Gemfile` 中没有包含这个插件，导致 Jekyll 构建失败。

## 已修复

### 1. 更新 Gemfile

已添加 `jekyll-remote-theme` 插件：

```ruby
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-remote-theme"  # 必需：用于加载 remote_theme
end
```

### 2. 更新 _config.yml

已在插件列表中添加 `jekyll-remote-theme`：

```yaml
plugins:
  - jekyll-feed
  - jekyll-seo-tag
  - jekyll-remote-theme  # 必需：用于加载 remote_theme
```

### 3. 更新工作流

已在构建命令中添加 `--verbose` 标志，以便更好地诊断问题：

```yaml
- name: Build with Jekyll
  run: bundle exec jekyll build --verbose
```

## 下一步操作

### 1. 重新安装依赖

在本地运行：

```bash
bundle install
```

这会安装 `jekyll-remote-theme` 插件。

### 2. 本地测试（可选但推荐）

```bash
bundle exec jekyll build
```

如果构建成功，说明配置正确。

### 3. 提交并推送

```bash
git add Gemfile Gemfile.lock _config.yml .github/workflows/jekyll.yml
git commit -m "添加 jekyll-remote-theme 插件以支持 remote_theme"
git push origin main
```

## 验证

推送后，GitHub Actions 应该能够：
1. ✅ 成功安装 `jekyll-remote-theme` 插件
2. ✅ 成功加载 `academic-pages` 主题
3. ✅ 成功构建网站

## 关于 jekyll-remote-theme

`jekyll-remote-theme` 是 GitHub Pages 官方支持的插件，用于从 GitHub 仓库加载 Jekyll 主题。它允许您：

- 使用 GitHub 上的任何 Jekyll 主题
- 无需将主题作为 gem 安装
- 主题更新会自动应用

**注意**：`jekyll-remote-theme` 是 GitHub Pages 白名单插件，完全支持。

---

**修复完成！请按照上述步骤操作。** 🚀

