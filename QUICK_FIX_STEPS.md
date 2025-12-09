# 快速修复步骤

## ✅ 代码已更新

`Gemfile` 和 `_config.yml` 已按照 GitHub Pages 标准配置完成。

## 📋 您需要执行的步骤

### 1. 删除 Gemfile.lock

在项目根目录执行：

```powershell
# PowerShell
Remove-Item Gemfile.lock
```

或者：

```bash
# Git Bash
rm Gemfile.lock
```

### 2. 重新安装依赖

```bash
bundle install
```

这会根据新的 `Gemfile` 安装 `github-pages` gem 及其依赖。

### 3. 提交并推送

```bash
git add Gemfile Gemfile.lock _config.yml
git commit -m "配置 GitHub Pages 兼容性：使用 github-pages gem 和 remote_theme"
git push origin main
```

## 🎯 完成！

推送后，GitHub Actions 会自动构建并部署网站。

---

**详细说明请查看：** [GITHUB_PAGES_COMPATIBILITY.md](GITHUB_PAGES_COMPATIBILITY.md)

