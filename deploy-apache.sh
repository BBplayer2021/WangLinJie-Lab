#!/bin/bash
# 使用 Apache 部署 Jekyll 网站的脚本
# 服务器信息：
# - 公网 IP: 47.109.88.129
# - 操作系统: Debian 11.6 64位
# 
# 使用方法: 
#   ./deploy-apache.sh                    # 使用默认配置
#   或
#   ./deploy-apache.sh root@47.109.88.129 /var/www/fishandgoat.cloud

set -e

# 默认配置
DEFAULT_SERVER="root@47.109.88.129"
DEFAULT_TARGET_DIR="/var/www/fishandgoat.cloud"

# 检查参数，如果没有提供则使用默认值
if [ $# -eq 0 ]; then
    SERVER=$DEFAULT_SERVER
    TARGET_DIR=$DEFAULT_TARGET_DIR
    echo "ℹ️  使用默认配置:"
    echo "   服务器: $SERVER"
    echo "   目标目录: $TARGET_DIR"
elif [ $# -eq 2 ]; then
    SERVER=$1
    TARGET_DIR=$2
else
    echo "使用方法: $0 [user@server-ip] [目标目录]"
    echo "示例: $0"
    echo "或: $0 root@47.109.88.129 /var/www/fishandgoat.cloud"
    exit 1
fi

echo "🚀 开始部署到阿里云服务器（Apache）..."
echo "服务器: $SERVER"
echo "目标目录: $TARGET_DIR"

# 步骤 1: 本地构建
echo ""
echo "📦 步骤 1: 构建 Jekyll 网站..."
bundle exec jekyll build

if [ ! -d "_site" ]; then
    echo "❌ 错误: _site 目录不存在，构建失败"
    exit 1
fi

echo "✅ 构建完成"

# 步骤 2: 上传文件
echo ""
echo "📤 步骤 2: 上传文件到服务器..."
rsync -avz --delete _site/ $SERVER:$TARGET_DIR/_site/

echo "✅ 文件上传完成"

# 步骤 3: 在服务器上设置权限
echo ""
echo "🔧 步骤 3: 设置文件权限..."
ssh $SERVER "sudo chown -R www-data:www-data $TARGET_DIR && sudo chmod -R 755 $TARGET_DIR"

echo "✅ 权限设置完成"

# 步骤 4: 重载 Apache
echo ""
echo "🔄 步骤 4: 重载 Apache..."
ssh $SERVER "sudo systemctl reload apache2"

echo ""
echo "🎉 部署完成！"
echo "网站应该已经更新，请访问: http://fishandgoat.cloud"

