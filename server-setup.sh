#!/bin/bash
# 阿里云 ECS 服务器初始化脚本
# 服务器信息：
# - 公网 IP: 47.109.88.129
# - 操作系统: Debian 11.6 64位
# - 实例规格: ecs.s6-c1m1.small (1核1GB)

set -e

echo "🚀 开始配置阿里云 ECS 服务器..."
echo "服务器 IP: 47.109.88.129"
echo "操作系统: Debian 11.6"

# 更新系统
echo ""
echo "📦 步骤 1: 更新系统..."
sudo apt update
sudo apt upgrade -y

# 安装 Nginx
echo ""
echo "📦 步骤 2: 安装 Nginx..."
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# 创建网站目录
echo ""
echo "📁 步骤 3: 创建网站目录..."
sudo mkdir -p /var/www/fishandgoat.cloud/_site
sudo chown -R $USER:$USER /var/www/fishandgoat.cloud

# 配置 Nginx
echo ""
echo "⚙️  步骤 4: 配置 Nginx..."
sudo tee /etc/nginx/sites-available/fishandgoat.cloud > /dev/null <<EOF
server {
    listen 80;
    server_name fishandgoat.cloud www.fishandgoat.cloud 47.109.88.129;
    
    root /var/www/fishandgoat.cloud/_site;
    index index.html index.htm;
    
    # 日志
    access_log /var/log/nginx/fishandgoat.cloud.access.log;
    error_log /var/log/nginx/fishandgoat.cloud.error.log;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # 静态资源缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # 禁止访问隐藏文件
    location ~ /\. {
        deny all;
    }
}
EOF

# 启用站点
sudo ln -sf /etc/nginx/sites-available/fishandgoat.cloud /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 测试 Nginx 配置
echo ""
echo "🔍 步骤 5: 测试 Nginx 配置..."
sudo nginx -t

# 重启 Nginx
sudo systemctl restart nginx

# 配置防火墙
echo ""
echo "🔥 步骤 6: 配置防火墙..."
if command -v ufw &> /dev/null; then
    sudo ufw allow 'Nginx Full'
    sudo ufw allow ssh
    sudo ufw --force enable
elif command -v firewall-cmd &> /dev/null; then
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
else
    echo "⚠️  未检测到防火墙工具，请手动配置安全组规则"
    echo "   在阿里云控制台开放端口: 80, 443, 22"
fi

echo ""
echo "✅ 服务器配置完成！"
echo ""
echo "📋 下一步："
echo "1. 在本地运行部署脚本: ./deploy-aliyun.sh root@47.109.88.129 /var/www/fishandgoat.cloud"
echo "2. 配置域名 DNS 解析到: 47.109.88.129"
echo "3. 配置 SSL 证书: sudo certbot --nginx -d fishandgoat.cloud -d www.fishandgoat.cloud"

