# Netlify 部署问题修复指南

## 问题描述
Netlify 构建失败，可能的原因：
1. Bundler 4.0.0 不支持 `--path` 标志
2. Ruby 3.1.7 安装时间过长导致超时
3. Netlify 未使用 netlify.toml 中的配置

## 解决方案

### 方案一：在 Netlify UI 中手动配置（推荐，解决 Ruby 安装超时）

1. 登录 Netlify，进入您的站点
2. 进入 **Site settings** → **Build & deploy** → **Build settings**
3. 点击 **Edit settings**（编辑设置）

4. 更新以下设置：

   **Build command**（构建命令）：
   ```bash
   bundle config set --local path 'vendor/bundle' && bundle install && bundle exec jekyll build
   ```

   **Publish directory**（发布目录）：
   ```
   _site
   ```

5. 在 **Environment variables**（环境变量）中添加：
   - `JEKYLL_ENV` = `production`
   - `RUBY_VERSION` = `3.3` （使用 Netlify 预装版本，避免长时间编译）

6. **重要**：确保 **"Use build settings from netlify.toml"** 选项是**关闭**的，这样才会使用 UI 中的设置

7. 点击 **Save** 保存设置
8. 返回站点概览，点击 **Trigger deploy** → **Clear cache and deploy site** 重新部署

### 方案二：使用 Jekyll 插件

1. 在 Netlify UI 中，进入 **Site settings** → **Plugins**
2. 搜索并安装 **"Jekyll"** 插件
3. 在 `netlify.toml` 中取消注释插件配置：
   ```toml
   [[plugins]]
     package = "@netlify/plugin-jekyll"
   ```
4. 移除或注释掉 `[build]` 中的 `command` 行
5. 提交并推送更改

### 方案三：降级 Bundler（在本地操作）

如果您想在本地锁定 Bundler 版本：

```bash
# 安装旧版本 Bundler
gem install bundler -v 2.4.22

# 使用旧版本重新安装依赖
bundle _2.4.22_ install

# 更新 Gemfile.lock
bundle _2.4.22_ update --bundler

# 提交更改
git add Gemfile.lock
git commit -m "Lock bundler to 2.4.22 for Netlify compatibility"
git push
```

### 方案四：使用备用构建脚本

如果上述方法都不行，可以创建一个构建脚本：

1. 确保 `build.sh` 文件存在且可执行
2. 在 Netlify 的构建命令中使用：
   ```bash
   chmod +x build.sh && ./build.sh
   ```

## 验证

部署成功后，检查：
- ✅ 构建日志显示 "Build successful"
- ✅ 网站可以正常访问
- ✅ 所有页面正常加载

## 如果仍然失败

请检查：
1. Netlify 构建日志的完整错误信息
2. 确保 `Gemfile` 和 `Gemfile.lock` 已提交到仓库
3. 确保 `_config.yml` 中的 URL 设置正确
4. 尝试清除 Netlify 的构建缓存

