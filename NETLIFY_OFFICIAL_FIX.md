# Netlify 官方 AI 解决方案

## 问题诊断

根据 Netlify 官方 AI 的诊断：

**错误类型**：Bundler 运行时错误（依赖安装阶段）

**原因**：
- Netlify 使用 Bundler 4.0.0（从 Gemfile.lock 检测到）
- Netlify 的依赖安装步骤自动使用已弃用的 `--path` 标志
- Bundler 4 移除了对 `--path` 的支持
- 导致 `bundle install` 失败

## 解决方案（已采用 Option B）

### Option B：在构建命令中设置 bundle path（已实现）

**优点**：
- ✅ 不需要修改 Gemfile.lock
- ✅ 不需要本地操作
- ✅ 使用新的推荐 API

**配置**（已在 `netlify.toml` 中实现）：
```toml
[build]
  command = "bundle config set path '/opt/build/cache/bundle' && bundle install && bundle exec jekyll build"
  publish = "_site"
```

这个命令：
1. 使用 `bundle config set path` 设置 gem 存储路径（新的推荐方式）
2. 运行 `bundle install` 安装依赖
3. 运行 `bundle exec jekyll build` 构建网站

这样避免了 Netlify 自动使用 `--path` 标志，从而解决了 Bundler 4.0 的兼容性问题。

## 备选方案：Option A（如果需要）

如果 Option B 不工作，可以使用 Option A：将 Bundler 降级到 2.x

### 步骤：

1. **本地安装 Bundler 2**：
   ```bash
   gem install bundler -v "~> 2.4"
   ```

2. **使用 Bundler 2 重新安装依赖**：
   ```bash
   bundle _2.4.0_ install
   bundle _2.4.0_ lock --add-platform ruby
   ```

3. **提交更改**：
   ```bash
   git add Gemfile.lock
   git commit -m "Pin bundler 2 to avoid --path removal on Netlify"
   git push
   ```

4. **重新部署**

## 验证

部署成功后，检查：
- ✅ 构建日志显示 "Build successful"
- ✅ 依赖安装成功
- ✅ Jekyll 构建成功
- ✅ 网站可以正常访问

## 参考

- Netlify 官方 AI 诊断
- [Netlify 依赖管理文档](https://docs.netlify.com/configure-builds/manage-dependencies/)

