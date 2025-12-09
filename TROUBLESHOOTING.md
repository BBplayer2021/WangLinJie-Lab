# 故障排查指南

## 重要说明

**Debian 11 是支持 Nginx 的**。如果遇到安装问题，通常是软件源配置的问题，而不是系统不支持。

如果确实无法安装 Nginx，可以使用 Apache 作为替代方案。Apache 是 Debian 默认包含的 Web 服务器，通常更容易安装。

查看替代方案：[ALTERNATIVE_WEB_SERVERS.md](ALTERNATIVE_WEB_SERVERS.md)

---

## Nginx 安装失败：404 Not Found

### 问题描述

安装 Nginx 时出现 404 错误：
```
Err:1 http://mirrors.cloud.aliyuncs.com/debian-security bullseye-security/main amd64 nginx-common all 1.18.0-6.1+deb11u4
  404  Not Found
```

### 原因

阿里云镜像源 (`mirrors.cloud.aliyuncs.com`) 可能没有同步最新的 Debian 安全更新包。

### 解决方案

#### 方案一：使用修复脚本（推荐）

```bash
# 上传修复脚本到服务器
scp fix-apt-sources.sh root@47.109.88.129:/root/

# SSH 登录服务器
ssh root@47.109.88.129

# 执行修复脚本
chmod +x fix-apt-sources.sh
./fix-apt-sources.sh

# 然后安装 Nginx
sudo apt install nginx -y
```

#### 方案二：手动修复软件源

```bash
# SSH 登录服务器
ssh root@47.109.88.129

# 备份原有配置
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# 编辑软件源配置
sudo nano /etc/apt/sources.list
```

替换为以下内容：

```bash
# Debian 11 (bullseye) 官方源
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free

# Debian 11 安全更新
deb http://deb.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security bullseye-security main contrib non-free

# Debian 11 更新
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free
```

保存后执行：

```bash
# 更新软件包列表
sudo apt update

# 安装 Nginx
sudo apt install nginx -y
```

#### 方案三：使用阿里云其他镜像源

如果希望继续使用阿里云镜像，可以尝试更换镜像源：

```bash
# 编辑软件源
sudo nano /etc/apt/sources.list
```

替换为：

```bash
# 阿里云杭州镜像
deb http://mirrors.aliyun.com/debian/ bullseye main contrib non-free
deb-src http://mirrors.aliyun.com/debian/ bullseye main contrib non-free

deb http://mirrors.aliyun.com/debian-security bullseye-security main contrib non-free
deb-src http://mirrors.aliyun.com/debian-security bullseye-security main contrib non-free

deb http://mirrors.aliyun.com/debian/ bullseye-updates main contrib non-free
deb-src http://mirrors.aliyun.com/debian/ bullseye-updates main contrib non-free
```

然后：

```bash
sudo apt update
sudo apt install nginx -y
```

### 验证安装

安装完成后验证：

```bash
# 检查 Nginx 版本
nginx -v

# 检查 Nginx 状态
sudo systemctl status nginx

# 启动 Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

## 其他常见问题

### 1. 软件包依赖问题

```bash
# 修复依赖
sudo apt --fix-broken install

# 清理缓存
sudo apt clean
sudo apt autoclean

# 更新软件包列表
sudo apt update
```

### 2. 磁盘空间不足

```bash
# 检查磁盘空间
df -h

# 清理不需要的软件包
sudo apt autoremove
sudo apt autoclean
```

### 3. 网络连接问题

```bash
# 测试网络连接
ping -c 4 deb.debian.org

# 如果无法连接，检查 DNS
cat /etc/resolv.conf

# 可以临时设置 DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### 4. 权限问题

```bash
# 确保使用 sudo
sudo apt install nginx -y

# 检查用户权限
whoami
groups
```

## 推荐方案

**推荐使用方案一（官方 Debian 源）**，因为：
- ✅ 最稳定可靠
- ✅ 包含所有软件包
- ✅ 更新及时
- ✅ 全球 CDN，速度快

如果在中国大陆，也可以使用方案三（阿里云杭州镜像），速度可能更快。

## 安装 Nginx 后的下一步

安装成功后，继续按照 [QUICK_START_ALIYUN.md](QUICK_START_ALIYUN.md) 或 [WORDPRESS_JEYLL_COEXIST.md](WORDPRESS_JEYLL_COEXIST.md) 进行配置。

