# 修复 GitHub Actions 构建错误

## 错误信息

```
The process '/opt/hostedtoolcache/Ruby/3.1.7/x64/bin/bundle' failed with exit code 16
```

## 问题原因

`Gemfile.lock` 文件是在 Windows 环境下生成的，包含了 Windows 特定的平台 gem（`x64-mingw-ucrt`），这些 gem 在 Linux 环境的 GitHub Actions 中无法安装，导致 `bundle install` 失败。

## 解决方案

### 方案一：更新工作流配置（已修复）

我已经更新了 `.github/workflows/jekyll.yml`，添加了清理 Windows 特定平台的步骤。

**操作**：
1. 提交更新的工作流文件
2. 推送到 GitHub
3. GitHub Actions 会自动重新运行

### 方案二：重新生成 Gemfile.lock（推荐，长期解决）

在 Linux 环境中重新生成 `Gemfile.lock`：

#### 方法 A：使用 GitHub Codespaces（如果可用）

1. 在 GitHub 仓库中，点击 **Code** → **Codespaces** → **Create codespace**
2. 在 Codespaces 中运行：
   ```bash
   bundle install
   bundle lock --add-platform ruby
   ```
3. 提交新的 `Gemfile.lock`

#### 方法 B：在本地使用 WSL 或 Linux 虚拟机

```bash
# 在 Linux 环境中
bundle install
bundle lock --add-platform ruby
git add Gemfile.lock
git commit -m "Regenerate Gemfile.lock for Linux"
git push
```

#### 方法 C：删除 Gemfile.lock，让 GitHub Actions 重新生成

1. 删除 `Gemfile.lock`（或重命名为 `Gemfile.lock.backup`）
2. 提交更改
3. GitHub Actions 会在 Linux 环境中重新生成

**注意**：删除 `Gemfile.lock` 后，首次构建可能需要更长时间。

## 当前修复

我已经更新了工作流文件，添加了以下步骤：

```yaml
- name: Remove Windows-specific gems from lockfile
  run: |
    # 删除 Windows 特定的平台，让 bundle 在 Linux 环境中重新解析
    sed -i '/x64-mingw-ucrt/d' Gemfile.lock || true
    sed -i '/PLATFORMS/,/^$/c\PLATFORMS\n  ruby\n' Gemfile.lock || true
```

这会自动清理 Windows 特定的平台信息，让 bundle 在 Linux 环境中正常工作。

## 下一步操作

1. **提交更新的工作流文件**：
   ```bash
   git add .github/workflows/jekyll.yml
   git commit -m "Fix bundle install error by removing Windows-specific platforms"
   git push origin main
   ```

2. **等待 GitHub Actions 运行**：
   - 进入 **Actions** 标签
   - 查看新的工作流运行
   - 应该会成功构建

3. **如果仍然失败**：
   - 查看构建日志中的具体错误
   - 考虑使用方案二（重新生成 Gemfile.lock）

## 验证

构建成功后：
- ✅ GitHub Actions 显示绿色勾号
- ✅ GitHub Pages 设置显示 "Your site is published"
- ✅ 访问 https://fishandgoat.cloud 显示网站内容

## 长期建议

为了避免将来出现类似问题：

1. **在 Linux 环境中生成 Gemfile.lock**（如果可能）
2. **或者添加多个平台**：
   ```bash
   bundle lock --add-platform ruby
   bundle lock --add-platform x86_64-linux
   ```
3. **使用 `.gitignore` 排除平台特定的文件**（但保留 `Gemfile.lock`）

---

**当前修复应该可以解决问题**。请提交更新的工作流文件并推送到 GitHub。

