# 阿里云 ECS 快速部署指南

## 服务器信息

- **公网 IP**: 47.109.88.129
- **私网 IP**: 172.31.101.113
- **操作系统**: Debian 11.6 64位 UEFI版
- **实例规格**: ecs.s6-c1m1.small (1核1GB)
- **域名**: fishandgoat.cloud

## ⚠️ 重要提示

**如果您的服务器上已经有 WordPress 网站**，请先查看：
👉 [WORDPRESS_JEYLL_COEXIST.md](WORDPRESS_JEYLL_COEXIST.md)

WordPress 和 Jekyll 可以在同一服务器上共存，有多种配置方案可选。

**如果无法安装 Nginx**，可以使用 Apache 作为替代：
👉 [ALTERNATIVE_WEB_SERVERS.md](ALTERNATIVE_WEB_SERVERS.md) - 包含 Apache 和 Caddy 的配置方法

## 快速部署步骤

### 第一步：在服务器上初始化（只需执行一次）

1. **SSH 登录服务器**：
   ```bash
   ssh root@47.109.88.129
   ```

2. **上传并执行初始化脚本**：
   ```bash
   # 在本地执行（上传脚本到服务器）
   scp server-setup.sh root@47.109.88.129:/root/
   
   # SSH 到服务器后执行
   ssh root@47.109.88.129
   chmod +x server-setup.sh
   ./server-setup.sh
   ```

   或者**手动执行**（如果无法上传脚本）：
   ```bash
   # SSH 登录服务器
   ssh root@47.109.88.129
   
   # ⚠️ 如果遇到 Nginx 安装 404 错误，先修复软件源
   # 查看故障排查指南: TROUBLESHOOTING.md
   # 或执行: scp fix-apt-sources.sh root@47.109.88.129:/root/ && ssh root@47.109.88.129 "./fix-apt-sources.sh"
   
   # 更新系统
   sudo apt update
   sudo apt upgrade -y
   
   # 安装 Nginx（如果失败，请查看 TROUBLESHOOTING.md）
   sudo apt install nginx -y
   sudo systemctl start nginx
   sudo systemctl enable nginx
   
   # 创建网站目录
   sudo mkdir -p /var/www/fishandgoat.cloud/_site
   sudo chown -R $USER:$USER /var/www/fishandgoat.cloud
   
   # 配置 Nginx（见下方配置内容）
   sudo nano /etc/nginx/sites-available/fishandgoat.cloud
   # 粘贴下面的 Nginx 配置
   
   # 启用站点
   sudo ln -s /etc/nginx/sites-available/fishandgoat.cloud /etc/nginx/sites-enabled/
   sudo rm -f /etc/nginx/sites-enabled/default
   sudo nginx -t
   sudo systemctl restart nginx
   ```

### 第二步：在本地部署网站（每次更新）

**使用快速部署脚本（推荐）**：

```bash
# 在本地项目目录执行
chmod +x deploy-aliyun.sh

# 使用默认配置（自动使用 47.109.88.129）
./deploy-aliyun.sh

# 或指定参数
./deploy-aliyun.sh root@47.109.88.129 /var/www/fishandgoat.cloud
```

**手动部署**：

```bash
# 1. 本地构建
bundle exec jekyll build

# 2. 上传文件
scp -r _site/* root@47.109.88.129:/var/www/fishandgoat.cloud/_site/

# 3. SSH 到服务器设置权限
ssh root@47.109.88.129
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud
sudo chmod -R 755 /var/www/fishandgoat.cloud
sudo systemctl reload nginx
```

## Nginx 配置文件

创建文件：`/etc/nginx/sites-available/fishandgoat.cloud`

```nginx
server {
    listen 80;
    server_name fishandgoat.cloud www.fishandgoat.cloud 47.109.88.129;
    
    root /var/www/fishandgoat.cloud/_site;
    index index.html index.htm;
    
    # 日志
    access_log /var/log/nginx/fishandgoat.cloud.access.log;
    error_log /var/log/nginx/fishandgoat.cloud.error.log;
    
    location / {
        try_files $uri $uri/ /index.html;
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
    
    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
}
```

## 配置域名 DNS

在您的域名注册商（fishandgoat.cloud）处配置 DNS 解析：

```
类型: A
主机记录: @
记录值: 47.109.88.129
TTL: 600

类型: A
主机记录: www
记录值: 47.109.88.129
TTL: 600
```

## 配置 SSL 证书（HTTPS）

```bash
# SSH 登录服务器
ssh root@47.109.88.129

# 安装 Certbot
sudo apt install certbot python3-certbot-nginx -y

# 获取 SSL 证书（需要先配置 DNS 解析）
sudo certbot --nginx -d fishandgoat.cloud -d www.fishandgoat.cloud

# 测试自动续期
sudo certbot renew --dry-run
```

## 配置阿里云安全组

在阿里云控制台配置安全组规则，开放以下端口：

- **22** (SSH) - 来源: 0.0.0.0/0 或您的 IP
- **80** (HTTP) - 来源: 0.0.0.0/0
- **443** (HTTPS) - 来源: 0.0.0.0/0

## 验证部署

部署完成后，访问：

- http://47.109.88.129 （IP 访问）
- http://fishandgoat.cloud （域名访问，需要 DNS 解析生效）
- https://fishandgoat.cloud （HTTPS，需要配置 SSL 证书）

## 常用命令

```bash
# 查看 Nginx 状态
sudo systemctl status nginx

# 重启 Nginx
sudo systemctl restart nginx

# 查看 Nginx 日志
sudo tail -f /var/log/nginx/fishandgoat.cloud.access.log
sudo tail -f /var/log/nginx/fishandgoat.cloud.error.log

# 测试 Nginx 配置
sudo nginx -t

# 查看网站文件
ls -la /var/www/fishandgoat.cloud/_site/
```

## 更新网站

每次更新网站内容后，只需在本地运行：

```bash
./deploy-aliyun.sh
```

脚本会自动完成构建、上传、设置权限和重载 Nginx。

## 故障排查

### 1. 无法访问网站

- 检查 Nginx 是否运行：`sudo systemctl status nginx`
- 检查安全组规则是否开放 80 端口
- 检查 DNS 解析是否正确

### 2. 403 Forbidden

```bash
# 检查文件权限
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud
sudo chmod -R 755 /var/www/fishandgoat.cloud
```

### 3. 502 Bad Gateway

- 检查 `_site` 目录是否存在且包含文件
- 检查 Nginx 错误日志：`sudo tail -f /var/log/nginx/fishandgoat.cloud.error.log`

## 性能优化建议

由于服务器配置为 1核1GB，建议：

1. **启用 Nginx 缓存**（已在配置中）
2. **使用 CDN**（可选）：将静态资源上传到阿里云 OSS
3. **定期清理日志**：
   ```bash
   sudo truncate -s 0 /var/log/nginx/*.log
   ```

## 备份

定期备份网站文件：

```bash
# 在服务器上执行
tar -czf /root/backup-$(date +%Y%m%d).tar.gz /var/www/fishandgoat.cloud
```

---

**需要帮助？** 查看详细文档：[ALIYUN_DEPLOYMENT.md](ALIYUN_DEPLOYMENT.md)

