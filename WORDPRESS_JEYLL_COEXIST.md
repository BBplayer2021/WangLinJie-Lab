# WordPress 与 Jekyll 共存部署指南

## 服务器信息

- **公网 IP**: 47.109.88.129
- **已有服务**: WordPress
- **新增服务**: Jekyll 网站 (fishandgoat.cloud)

## 方案选择

### 方案一：使用不同域名/子域名（推荐 ⭐）

**优点**：
- ✅ 配置简单
- ✅ 互不干扰
- ✅ 易于管理
- ✅ 可以分别配置 SSL

**配置方式**：
- WordPress: `your-wordpress-domain.com`
- Jekyll: `fishandgoat.cloud`

### 方案二：使用不同路径（推荐 ⭐⭐）

**优点**：
- ✅ 同一域名下
- ✅ 配置灵活
- ✅ 易于维护

**配置方式**：
- WordPress: `your-domain.com/` 或 `your-domain.com/blog/`
- Jekyll: `your-domain.com/` 或 `your-domain.com/lab/`

### 方案三：使用不同端口（不推荐）

**缺点**：
- ❌ 需要修改访问方式（如 `domain.com:8080`）
- ❌ 用户体验差
- ❌ SSL 配置复杂

## 方案一详细配置：不同域名

### 步骤 1：检查现有 Nginx 配置

```bash
# SSH 登录服务器
ssh root@47.109.88.129

# 查看现有 Nginx 配置
ls -la /etc/nginx/sites-available/
ls -la /etc/nginx/sites-enabled/

# 查看 WordPress 配置
cat /etc/nginx/sites-available/default
# 或
cat /etc/nginx/sites-enabled/default
```

### 步骤 2：创建 Jekyll 站点配置

```bash
# 创建 Jekyll 网站目录
sudo mkdir -p /var/www/fishandgoat.cloud/_site
sudo chown -R www-data:www-data /var/www/fishandgoat.cloud

# 创建 Nginx 配置文件
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
    
    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
}
```

### 步骤 3：启用 Jekyll 站点

```bash
# 创建符号链接
sudo ln -s /etc/nginx/sites-available/fishandgoat.cloud /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重载 Nginx（不会影响 WordPress）
sudo systemctl reload nginx
```

### 步骤 4：配置 DNS

在域名注册商处为 `fishandgoat.cloud` 添加 A 记录：
```
类型: A
主机记录: @
记录值: 47.109.88.129
TTL: 600
```

## 方案二详细配置：不同路径

### 场景 A：Jekyll 在根目录，WordPress 在子目录

假设您想让 Jekyll 网站在根目录，WordPress 在 `/blog/` 目录：

**修改 WordPress 的 Nginx 配置**：

```nginx
# WordPress 配置（/etc/nginx/sites-available/wordpress）
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    
    # Jekyll 网站（根目录）
    root /var/www/fishandgoat.cloud/_site;
    index index.html;
    
    # WordPress（子目录）
    location /blog/ {
        alias /var/www/wordpress/;
        try_files $uri $uri/ /blog/index.php?$args;
        
        location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $request_filename;
            include fastcgi_params;
        }
    }
    
    # Jekyll 静态文件
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### 场景 B：WordPress 在根目录，Jekyll 在子目录

假设您想让 WordPress 在根目录，Jekyll 在 `/lab/` 目录：

**修改 Nginx 配置**：

```nginx
# 主配置（/etc/nginx/sites-available/default）
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    
    # WordPress（根目录）
    root /var/www/wordpress;
    index index.php index.html;
    
    # WordPress PHP 处理
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    
    # Jekyll 网站（子目录）
    location /lab/ {
        alias /var/www/fishandgoat.cloud/_site/;
        try_files $uri $uri/ /lab/index.html;
        
        # 静态资源
        location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
```

**重要**：需要修改 Jekyll 的 `_config.yml`：

```yaml
baseurl: "/lab"  # 添加这行
url: "https://your-domain.com"
```

然后重新构建：
```bash
bundle exec jekyll build
```

## 方案三：使用子域名

如果您有多个域名或可以使用子域名：

- WordPress: `www.your-domain.com` 或 `blog.your-domain.com`
- Jekyll: `lab.your-domain.com` 或 `fishandgoat.cloud`

配置方式与方案一相同，只需修改 `server_name`。

## 部署 Jekyll 网站

无论使用哪种方案，部署步骤相同：

```bash
# 在本地执行
./deploy-aliyun.sh root@47.109.88.129 /var/www/fishandgoat.cloud
```

## 配置 SSL 证书

### 为不同域名配置 SSL

```bash
# 为 Jekyll 网站配置 SSL
sudo certbot --nginx -d fishandgoat.cloud -d www.fishandgoat.cloud

# 为 WordPress 配置 SSL（如果还没有）
sudo certbot --nginx -d your-wordpress-domain.com -d www.your-wordpress-domain.com
```

### 为同一域名的不同路径配置 SSL

只需为域名配置一次 SSL，所有路径都会自动使用 HTTPS。

## 资源占用考虑

您的服务器配置：1核1GB

**资源分配**：
- WordPress（PHP-FPM + MySQL）：约 300-500MB
- Nginx：约 10-20MB
- Jekyll（静态文件）：几乎不占用运行时资源

**建议**：
- ✅ 1GB 内存足够运行 WordPress + Jekyll
- ✅ Jekyll 是静态网站，不占用运行时资源
- ⚠️ 如果 WordPress 访问量大，考虑优化或升级配置

## 性能优化

### 1. 启用 Nginx 缓存

在 Jekyll 配置中添加：

```nginx
# 缓存配置
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=jekyll_cache:10m max_size=100m inactive=60m;
proxy_cache_key "$scheme$request_method$host$request_uri";

location / {
    proxy_cache jekyll_cache;
    proxy_cache_valid 200 60m;
    try_files $uri $uri/ /index.html;
}
```

### 2. 优化 WordPress

- 使用缓存插件（如 WP Super Cache）
- 优化数据库
- 压缩图片

## 常见问题

### 1. 两个网站冲突

**问题**：访问一个网站时显示另一个网站的内容

**解决**：检查 Nginx 配置中的 `server_name` 是否正确，确保每个站点有独立的配置。

### 2. 静态资源 404

**问题**：Jekyll 的 CSS/JS 文件无法加载

**解决**：
- 检查 `baseurl` 配置
- 检查文件路径是否正确
- 检查 Nginx `location` 配置

### 3. WordPress 功能异常

**问题**：添加 Jekyll 后 WordPress 出现问题

**解决**：
- 检查 PHP-FPM 是否正常运行
- 检查 WordPress 的 `location` 配置
- 查看 Nginx 错误日志

## 推荐方案

**推荐使用方案一（不同域名）**，因为：
- ✅ 配置最简单
- ✅ 互不干扰
- ✅ 易于维护和扩展
- ✅ 可以独立配置 SSL
- ✅ 不影响现有 WordPress 网站

## 验证部署

部署完成后访问：
- WordPress: `http://your-wordpress-domain.com`
- Jekyll: `http://fishandgoat.cloud` 或 `http://47.109.88.129`（如果配置了 IP 访问）

## 下一步

1. 选择适合的方案
2. 按照对应方案的步骤配置
3. 部署 Jekyll 网站
4. 配置 SSL 证书
5. 测试两个网站是否都正常工作

---

**需要帮助？** 如果遇到问题，请检查：
- Nginx 配置语法：`sudo nginx -t`
- Nginx 错误日志：`sudo tail -f /var/log/nginx/error.log`
- 网站访问日志：`sudo tail -f /var/log/nginx/access.log`

