# 替代 Web 服务器方案

## 说明

**重要**：Debian 11 实际上是支持 Nginx 的。如果遇到安装问题，通常是软件源配置的问题，而不是系统不支持。

但如果确实无法安装 Nginx，可以使用以下替代方案：

## 方案一：使用 Apache（推荐替代方案）

Apache 是 Debian 默认包含的 Web 服务器，通常更容易安装。

### 安装 Apache

```bash
# SSH 登录服务器
ssh root@47.109.88.129

# 安装 Apache
sudo apt update
sudo apt install apache2 -y

# 启动 Apache
sudo systemctl start apache2
sudo systemctl enable apache2
```

### 配置 Apache 服务 Jekyll 网站

```bash
# 创建网站目录
sudo mkdir -p /var/www/fishandgoat.cloud/_site
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud

# 创建 Apache 虚拟主机配置
sudo nano /etc/apache2/sites-available/fishandgoat.cloud.conf
```

添加以下配置：

```apache
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
    ErrorLog ${APACHE_LOG_DIR}/fishandgoat.cloud_error.log
    CustomLog ${APACHE_LOG_DIR}/fishandgoat.cloud_access.log combined
</VirtualHost>
```

启用站点：

```bash
# 启用站点
sudo a2ensite fishandgoat.cloud.conf

# 禁用默认站点（可选）
sudo a2dissite 000-default.conf

# 启用必要的模块
sudo a2enmod rewrite

# 测试配置
sudo apache2ctl configtest

# 重启 Apache
sudo systemctl restart apache2
```

## 方案二：使用 Caddy（现代化，自动 HTTPS）

Caddy 是一个现代化的 Web 服务器，自动配置 HTTPS。

### 安装 Caddy

```bash
# SSH 登录服务器
ssh root@47.109.88.129

# 安装必要的工具
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https

# 添加 Caddy 仓库
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list

# 更新并安装
sudo apt update
sudo apt install caddy -y
```

### 配置 Caddy

```bash
# 创建网站目录
sudo mkdir -p /var/www/fishandgoat.cloud/_site
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud

# 创建 Caddy 配置
sudo nano /etc/caddy/Caddyfile
```

添加配置：

```
fishandgoat.cloud, www.fishandgoat.cloud {
    root * /var/www/fishandgoat.cloud/_site
    file_server
    
    # 自动 HTTPS（Caddy 会自动配置）
    encode gzip
}
```

启动 Caddy：

```bash
# 启动 Caddy
sudo systemctl start caddy
sudo systemctl enable caddy

# 检查状态
sudo systemctl status caddy
```

## 方案三：使用 Python 简单 HTTP 服务器（仅测试用）

**注意**：此方案仅适用于测试，不适合生产环境。

```bash
# 安装 Python（通常已安装）
sudo apt install python3 -y

# 进入网站目录
cd /var/www/fishandgoat.cloud/_site

# 启动简单 HTTP 服务器（端口 8000）
python3 -m http.server 8000

# 或使用 nohup 后台运行
nohup python3 -m http.server 8000 > /dev/null 2>&1 &
```

访问：`http://47.109.88.129:8000`

## 方案四：修复 Nginx 安装问题（推荐）

如果可能，建议修复 Nginx 安装问题，因为它是生产环境的最佳选择。

### 检查为什么无法安装

```bash
# 检查软件源
cat /etc/apt/sources.list

# 尝试更新
sudo apt update

# 查看详细错误
sudo apt install nginx -y 2>&1 | tee nginx-install.log
```

### 使用修复脚本

```bash
# 上传修复脚本
scp fix-apt-sources.sh root@47.109.88.129:/root/

# 执行修复
ssh root@47.109.88.129
chmod +x fix-apt-sources.sh
./fix-apt-sources.sh

# 再次尝试安装
sudo apt install nginx -y
```

## 方案对比

| Web 服务器 | 优点 | 缺点 | 推荐度 |
|-----------|------|------|--------|
| **Nginx** | 高性能、低资源占用、配置灵活 | 需要修复安装问题 | ⭐⭐⭐⭐⭐ |
| **Apache** | 稳定、易安装、功能丰富 | 资源占用稍高 | ⭐⭐⭐⭐ |
| **Caddy** | 自动 HTTPS、配置简单 | 相对较新 | ⭐⭐⭐⭐ |
| **Python HTTP** | 简单快速 | 仅适合测试 | ⭐ |

## 推荐方案

1. **首选**：修复 Nginx 安装问题（使用 `fix-apt-sources.sh`）
2. **备选**：使用 Apache（如果 Nginx 确实无法安装）
3. **现代化选择**：使用 Caddy（如果需要自动 HTTPS）

## 更新部署脚本

如果使用 Apache 或 Caddy，需要修改部署脚本中的重载命令：

### Apache 版本

修改 `deploy-aliyun.sh` 中的最后一步：

```bash
# 将
ssh $SERVER "sudo systemctl reload nginx"

# 改为
ssh $SERVER "sudo systemctl reload apache2"
```

### Caddy 版本

```bash
# 将
ssh $SERVER "sudo systemctl reload nginx"

# 改为
ssh $SERVER "sudo systemctl reload caddy"
```

## 配置 SSL 证书

### Apache + Let's Encrypt

```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d fishandgoat.cloud -d www.fishandgoat.cloud
```

### Caddy

Caddy 会自动配置 HTTPS，无需手动操作。

## 需要帮助？

- 如果选择 Apache：参考 [Apache 官方文档](https://httpd.apache.org/docs/)
- 如果选择 Caddy：参考 [Caddy 官方文档](https://caddyserver.com/docs/)
- 如果修复 Nginx：参考 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

