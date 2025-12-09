#!/bin/bash
# 修复 Debian 11 阿里云镜像源问题
# 解决 Nginx 安装 404 错误

set -e

echo "🔧 修复 Debian 软件源配置..."

# 备份原有源
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d)

# 检查当前 Debian 版本
DEBIAN_VERSION=$(lsb_release -cs)
echo "检测到 Debian 版本: $DEBIAN_VERSION"

# 创建新的 sources.list
sudo tee /etc/apt/sources.list > /dev/null <<EOF
# Debian 11 (bullseye) 官方源
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free

# Debian 11 安全更新
deb http://deb.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security bullseye-security main contrib non-free

# Debian 11 更新
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free
EOF

echo "✅ 已更新软件源为官方 Debian 源"

# 更新软件包列表
echo ""
echo "📦 更新软件包列表..."
sudo apt update

echo ""
echo "✅ 软件源修复完成！"
echo ""
echo "现在可以尝试安装 Nginx:"
echo "sudo apt install nginx -y"

