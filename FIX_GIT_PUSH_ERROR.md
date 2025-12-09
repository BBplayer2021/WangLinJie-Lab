# 修复 Git Push 连接错误

## 错误信息

```
fatal: unable to access 'https://github.com/BBplayer2021/WangLinJie-Lab.git/': Recv failure: Connection was reset
```

## 问题原因

这是网络连接问题，可能的原因：
1. HTTPS 连接不稳定或被重置
2. 防火墙或网络代理问题
3. Git 缓冲区设置过小
4. 网络超时设置过短

## 解决方案

### 方案一：增加 Git 缓冲区和超时设置（推荐先试）

```bash
# 增加 HTTP 缓冲区大小
git config --global http.postBuffer 524288000

# 增加超时时间
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999

# 禁用 SSL 验证（仅临时，不推荐长期使用）
# git config --global http.sslVerify false
```

然后重试：
```bash
git push origin main
```

### 方案二：切换到 SSH（推荐长期使用）

#### 步骤 1：检查是否已有 SSH 密钥

```bash
ls ~/.ssh/id_rsa.pub
# 或
ls ~/.ssh/id_ed25519.pub
```

#### 步骤 2：如果没有，生成 SSH 密钥

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# 按 Enter 使用默认路径
# 设置密码（可选）
```

#### 步骤 3：添加 SSH 密钥到 GitHub

1. 复制公钥内容：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   # 或
   cat ~/.ssh/id_rsa.pub
   ```

2. 在 GitHub 中添加：
   - 进入 **Settings** → **SSH and GPG keys**
   - 点击 **New SSH key**
   - 粘贴公钥内容
   - 保存

#### 步骤 4：更改远程仓库地址为 SSH

```bash
git remote set-url origin git@github.com:BBplayer2021/WangLinJie-Lab.git
```

#### 步骤 5：测试 SSH 连接

```bash
ssh -T git@github.com
```

应该看到：`Hi BBplayer2021! You've successfully authenticated...`

#### 步骤 6：推送

```bash
git push origin main
```

### 方案三：配置代理（如果使用代理）

如果您使用代理访问 GitHub：

```bash
# HTTP 代理
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy https://proxy.example.com:8080

# SOCKS5 代理
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

# 取消代理
# git config --global --unset http.proxy
# git config --global --unset https.proxy
```

### 方案四：使用 GitHub CLI（gh）

如果安装了 GitHub CLI：

```bash
gh auth login
gh repo sync
```

### 方案五：分块推送（如果文件很大）

```bash
# 增加缓冲区后重试
git config --global http.postBuffer 1048576000
git push origin main
```

## 快速修复命令（方案一）

直接执行以下命令，然后重试推送：

```bash
git config --global http.postBuffer 524288000
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
git push origin main
```

## 推荐方案

**长期推荐使用 SSH**（方案二），因为：
- ✅ 更稳定可靠
- ✅ 不需要每次输入密码（如果配置了 SSH 密钥）
- ✅ 不受 HTTPS 连接问题影响
- ✅ 更安全

## 验证

推送成功后，您应该看到：

```
Enumerating objects: X, done.
Counting objects: 100% (X/X), done.
Delta compression using up to X threads
Compressing objects: 100% (X/X), done.
Writing objects: 100% (X/X), X.XX KiB | X.XX MiB/s, done.
Total X (delta X), reused X (delta X), pack-reused X
remote: Resolving deltas: 100% (X/X), completed with X local objects.
To https://github.com/BBplayer2021/WangLinJie-Lab.git
   xxxxxxx..xxxxxxx  main -> main
```

---

**如果所有方案都失败，请检查：**
1. 网络连接是否稳定
2. 防火墙设置
3. 是否在公司网络（可能有代理限制）
4. GitHub 服务状态：https://www.githubstatus.com/

