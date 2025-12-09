# 阿里云服务器部署指南

本指南将帮助您将 Jekyll 网站部署到阿里云服务器上。

## 前置要求

- 阿里云 ECS 服务器（推荐 Ubuntu 20.04/22.04 或 CentOS 7/8）
- 服务器已配置 SSH 访问
- 域名已解析到服务器 IP（可选，但推荐）

## 方案一：使用 Nginx 部署静态文件（推荐）

### 步骤 1：在本地构建网站

```bash
# 在本地项目目录
bundle install
bundle exec jekyll build
```

构建完成后，`_site` 目录包含所有静态文件。

### 步骤 2：在服务器上安装 Nginx

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

**CentOS/RHEL:**
```bash
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 步骤 3：上传网站文件到服务器

**方法 A：使用快速部署脚本（推荐）**

```bash
# 在本地项目目录执行
chmod +x deploy-aliyun.sh
./deploy-aliyun.sh root@your-server-ip /var/www/fishandgoat.cloud
```

脚本会自动：
- 构建 Jekyll 网站
- 上传文件到服务器
- 设置文件权限
- 重载 Nginx

**方法 B：使用 SCP 手动上传**

```bash
# 在本地项目目录执行
scp -r _site/* root@your-server-ip:/var/www/fishandgoat.cloud/
```

**方法 B：使用 Git + 服务器构建（推荐）**

在服务器上克隆仓库并构建：

```bash
# SSH 登录服务器
ssh root@your-server-ip

# 安装必要软件
sudo apt update
sudo apt install git ruby-full build-essential -y

# 安装 Bundler
gem install bundler

# 克隆仓库
cd /var/www
sudo git clone https://github.com/BBplayer2021/WangLinJie-Lab.git fishandgoat.cloud
cd fishandgoat.cloud

# 安装依赖并构建
bundle install
bundle exec jekyll build

# 设置权限
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud
```

### 步骤 4：配置 Nginx

创建 Nginx 配置文件：

```bash
sudo nano /etc/nginx/sites-available/fishandgoat.cloud
```

添加以下配置：

```nginx
server {
    listen 80;
    server_name fishandgoat.cloud www.fishandgoat.cloud;
    
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
}
```

启用站点：

```bash
# Ubuntu/Debian
sudo ln -s /etc/nginx/sites-available/fishandgoat.cloud /etc/nginx/sites-enabled/

# CentOS/RHEL（直接创建配置文件）
sudo nano /etc/nginx/conf.d/fishandgoat.cloud.conf
# 粘贴上面的配置内容

# 测试配置
sudo nginx -t

# 重启 Nginx
sudo systemctl restart nginx
```

### 步骤 5：配置防火墙

```bash
# Ubuntu/Debian (UFW)
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw enable

# CentOS/RHEL (firewalld)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 步骤 6：配置 SSL 证书（使用 Let's Encrypt）

```bash
# 安装 Certbot
sudo apt install certbot python3-certbot-nginx -y

# 获取证书
sudo certbot --nginx -d fishandgoat.cloud -d www.fishandgoat.cloud

# 自动续期
sudo certbot renew --dry-run
```

## 方案二：使用 Git Hooks 自动部署

### 设置自动部署脚本

在服务器上创建部署脚本：

```bash
sudo nano /var/www/fishandgoat.cloud/deploy.sh
```

添加以下内容：

```bash
#!/bin/bash
cd /var/www/fishandgoat.cloud
git pull origin main
bundle install
bundle exec jekyll build
sudo systemctl reload nginx
echo "Deployment completed at $(date)"
```

设置执行权限：

```bash
sudo chmod +x /var/www/fishandgoat.cloud/deploy.sh
```

### 配置 Git Webhook（可选）

如果需要通过 GitHub Webhook 自动触发部署，可以使用 `webhook` 工具或编写简单的 HTTP 服务。

## 方案三：使用 Docker 部署（高级）

### 创建 Dockerfile

```dockerfile
FROM ruby:3.3.5

WORKDIR /app

# 安装依赖
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 复制源代码
COPY . .

# 构建网站
RUN bundle exec jekyll build

# 使用 Nginx 提供静态文件
FROM nginx:alpine
COPY --from=0 /app/_site /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 构建和运行

```bash
docker build -t fishandgoat-cloud .
docker run -d -p 80:80 --name fishandgoat-cloud fishandgoat-cloud
```

## 更新网站内容

### 方法 1：手动更新

```bash
# 在本地构建
bundle exec jekyll build

# 上传到服务器
scp -r _site/* root@your-server-ip:/var/www/fishandgoat.cloud/_site/
```

### 方法 2：使用 Git 自动更新

```bash
# SSH 到服务器
ssh root@your-server-ip

# 进入网站目录
cd /var/www/fishandgoat.cloud

# 拉取最新代码并构建
git pull origin main
bundle exec jekyll build
sudo systemctl reload nginx
```

## 性能优化

### 1. 启用 Gzip 压缩

在 Nginx 配置中添加：

```nginx
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
```

### 2. 配置缓存

已在配置文件中包含静态资源缓存。

### 3. 使用 CDN（可选）

可以将静态资源（图片、CSS、JS）上传到阿里云 OSS 并使用 CDN 加速。

## 监控和维护

### 查看 Nginx 日志

```bash
# 访问日志
sudo tail -f /var/log/nginx/fishandgoat.cloud.access.log

# 错误日志
sudo tail -f /var/log/nginx/fishandgoat.cloud.error.log
```

### 检查服务状态

```bash
sudo systemctl status nginx
```

### 重启服务

```bash
sudo systemctl restart nginx
```

## 常见问题

### 1. 403 Forbidden 错误

```bash
# 检查文件权限
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud
sudo chmod -R 755 /var/www/fishandgoat.cloud
```

### 2. 502 Bad Gateway

检查 Jekyll 构建是否成功，确保 `_site` 目录存在且包含文件。

### 3. 域名无法访问

- 检查 DNS 解析是否正确
- 检查防火墙规则
- 检查 Nginx 配置语法：`sudo nginx -t`

## 安全建议

1. **定期更新系统**：
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **配置 SSH 密钥认证**（禁用密码登录）

3. **使用防火墙**限制不必要的端口

4. **定期备份**网站文件：
   ```bash
   tar -czf backup-$(date +%Y%m%d).tar.gz /var/www/fishandgoat.cloud
   ```

5. **监控服务器资源**使用情况

## 成本对比

- **Netlify**：免费（有限制）或付费
- **阿里云 ECS**：按需付费，通常每月几十到几百元
- **优势**：完全控制、无流量限制、可自定义配置

## 总结

推荐使用**方案一（Nginx + 静态文件）**，因为：
- ✅ 简单易用
- ✅ 性能好
- ✅ 资源占用少
- ✅ 易于维护

如果需要自动化部署，可以结合 Git Hooks 或 CI/CD 工具。

