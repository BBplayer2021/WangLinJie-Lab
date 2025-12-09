#!/bin/bash
# 使用 Apache 部署 Jekyll 网站的初始化脚本
# 服务器信息：
# - 公网 IP: 47.109.88.129
# - 操作系统: Debian 11.6 64位

set -e

echo "🚀 开始配置 Apache Web 服务器..."
echo "服务器 IP: 47.109.88.129"
echo "操作系统: Debian 11.6"

# 更新系统
echo ""
echo "📦 步骤 1: 更新系统..."
sudo apt update
sudo apt upgrade -y

# 安装 Apache
echo ""
echo "📦 步骤 2: 安装 Apache..."
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2

# 创建网站目录
echo ""
echo "📁 步骤 3: 创建网站目录..."
sudo mkdir -p /var/www/fishandgoat.cloud/_site
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud

# 配置 Apache
echo ""
echo "⚙️  步骤 4: 配置 Apache..."
sudo tee /etc/apache2/sites-available/fishandgoat.cloud.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName fishandgoat.cloud
    ServerAlias www.fishandgoat.cloud 47.109.88.129
    
    DocumentRoot /var/www/fishandgoat.cloud/_site
    
    <Directory /var/www/fishandgoat.cloud/_site>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # 日志
    ErrorLog \${APACHE_LOG_DIR}/fishandgoat.cloud_error.log
    CustomLog \${APACHE_LOG_DIR}/fishandgoat.cloud_access.log combined
    
    # Gzip 压缩
    <IfModule mod_deflate.c>
        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript application/json
    </IfModule>
</VirtualHost>
EOF

# 启用站点和模块
echo ""
echo "🔧 步骤 5: 启用站点和模块..."
sudo a2ensite fishandgoat.cloud.conf
sudo a2dissite 000-default.conf
sudo a2enmod rewrite
sudo a2enmod deflate

# 测试 Apache 配置
echo ""
echo "🔍 步骤 6: 测试 Apache 配置..."
sudo apache2ctl configtest

# 重启 Apache
sudo systemctl restart apache2

# 配置防火墙
echo ""
echo "🔥 步骤 7: 配置防火墙..."
if command -v ufw &> /dev/null; then
    sudo ufw allow 'Apache Full'
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
echo "✅ Apache 配置完成！"
echo ""
echo "📋 下一步："
echo "1. 在本地运行部署脚本: ./deploy-apache.sh"
echo "2. 配置域名 DNS 解析到: 47.109.88.129"
echo "3. 配置 SSL 证书: sudo certbot --apache -d fishandgoat.cloud -d www.fishandgoat.cloud"

