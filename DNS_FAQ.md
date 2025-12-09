# DNS 设置常见问题 FAQ

## 问题 1：DNS 记录值大小写问题

### 问题
输入 `BBplayer2021.github.io` 后，保存显示为 `bbplayer2021.github.io`（小写）

### 答案
**这是完全正常的，不会影响 DNS 解析！**

**原因**：
- DNS（域名系统）是**不区分大小写**的
- 所有 DNS 记录值都会被标准化为小写
- 这是 DNS 协议的标准行为

**验证**：
- `BBplayer2021.github.io` = `bbplayer2021.github.io` = `BbPlAyEr2021.GiThUb.Io`
- 它们都指向同一个地址

**结论**：
- ✅ 可以正常使用
- ✅ 不会影响网站访问
- ✅ 不需要修改

## 问题 2：如何验证 DNS 解析是否正确

### 方法 1：使用命令行

```bash
# Windows PowerShell
nslookup fishandgoat.cloud

# 应该显示类似：
# Name:    bbplayer2021.github.io
# Addresses: 185.199.108.153
#           185.199.109.153
#           185.199.110.153
#           185.199.111.153
```

### 方法 2：在线工具

访问以下网站检查：
- https://www.whatsmydns.net/#CNAME/fishandgoat.cloud
- https://dnschecker.org/#CNAME/fishandgoat.cloud
- https://tool.chinaz.com/dns/

输入 `fishandgoat.cloud`，应该显示解析到 `bbplayer2021.github.io`

### 方法 3：在 GitHub 验证

1. 在 GitHub 仓库中，进入 **Settings** → **Pages**
2. 在 **Custom domain** 部分应该显示：
   - ✅ "DNS check successful"
   - ✅ 绿色勾号
   - ✅ "Your site is published at https://fishandgoat.cloud"

## 问题 3：DNS 解析需要多长时间

- **通常**：几分钟到几小时
- **最长**：最多 48 小时
- **影响因素**：
  - TTL 设置（建议 600，即 10 分钟）
  - 本地 DNS 缓存
  - 全球 DNS 服务器同步

## 问题 4：如何清除本地 DNS 缓存

### Windows

```powershell
# 以管理员身份运行 PowerShell
ipconfig /flushdns
```

### 验证清除是否成功

```powershell
# 清除后再次查询
nslookup fishandgoat.cloud
```

## 问题 5：CNAME 和 A 记录的区别

### CNAME 记录（推荐）

**优点**：
- ✅ 配置简单（只需一条记录）
- ✅ GitHub 更新 IP 时自动生效
- ✅ 维护方便

**配置**：
```
@    CNAME    bbplayer2021.github.io
```

### A 记录

**优点**：
- ✅ 解析速度稍快
- ✅ 某些情况下更稳定

**缺点**：
- ❌ 需要添加 4 条记录
- ❌ GitHub 更新 IP 时需要手动更新

**配置**：
```
@    A    185.199.108.153
@    A    185.199.109.153
@    A    185.199.110.153
@    A    185.199.111.153
```

**推荐**：使用 CNAME 记录（更简单）

## 问题 6：为什么需要添加两条记录（@ 和 www）

- `@` 记录：用于 `fishandgoat.cloud`（主域名）
- `www` 记录：用于 `www.fishandgoat.cloud`（www 子域名）

这样无论用户访问哪个地址，都能正常访问网站。

## 问题 9：主域名正常，但 www 子域名显示错误

### 问题现象

在 GitHub Pages 设置中：
- ✅ `fishandgoat.cloud` 显示 "DNS valid for primary"（主域名正常）
- ❌ `www.fishandgoat.cloud` 显示 "is improperly configured"（www 子域名错误）

### 可能的原因

1. **www 的 CNAME 记录未添加或配置错误**
2. **DNS 记录值不正确**
3. **DNS 传播未完成**（需要等待）
4. **TTL 设置过长**（建议设置为 600）

### 解决方法

#### 步骤 1：检查阿里云 DNS 解析

1. 登录阿里云控制台 → **域名解析 DNS**
2. 找到 `fishandgoat.cloud` → 点击 **"解析设置"**
3. 检查是否有 `www` 记录：
   - 如果没有，需要添加
   - 如果有，检查记录值是否正确

#### 步骤 2：添加或修改 www 记录

**如果不存在 www 记录**，添加：

```
记录类型：CNAME
主机记录：www
记录值：bbplayer2021.github.io
TTL：600
```

**如果已存在但错误**，修改为：

```
记录类型：CNAME
主机记录：www
记录值：bbplayer2021.github.io（确保与主域名记录值相同）
TTL：600（建议设置为较短时间，便于快速生效）
```

#### 步骤 3：验证 DNS 解析

使用在线工具验证：

1. 访问：https://www.whatsmydns.net/#CNAME/www.fishandgoat.cloud
2. 或访问：https://dnschecker.org/#CNAME/www.fishandgoat.cloud
3. 输入 `www.fishandgoat.cloud`
4. 应该显示解析到 `bbplayer2021.github.io`

#### 步骤 4：等待 DNS 传播

- **通常**：几分钟到几小时
- **最长**：最多 48 小时
- 如果 TTL 设置为 600（10 分钟），通常更快生效

#### 步骤 5：在 GitHub 中重新检查

1. 在 GitHub Pages 设置中，点击 **"Check again"** 按钮
2. 等待几秒钟
3. 如果仍然显示错误，等待一段时间后重试

### 临时解决方案

如果急需使用，可以：

1. **暂时移除 www 子域名**：
   - 在 GitHub Pages 设置中，只保留主域名 `fishandgoat.cloud`
   - 用户访问 `www.fishandgoat.cloud` 时，可以设置重定向到主域名

2. **或者等待 DNS 传播完成**（推荐）

### 验证配置

确保阿里云 DNS 解析中有以下两条记录：

| 记录类型 | 主机记录 | 记录值 | TTL | 状态 |
|---------|---------|--------|-----|------|
| CNAME | @ | bbplayer2021.github.io | 600 | ✅ 正常 |
| CNAME | www | bbplayer2021.github.io | 600 | ⚠️ 检查中 |

### 常见错误

1. **记录值拼写错误**：检查是否输入了正确的 GitHub 用户名
2. **记录类型错误**：确保使用 CNAME，不是 A 记录
3. **主机记录错误**：确保是 `www`，不是 `www.` 或其他
4. **TTL 过长**：建议设置为 600（10 分钟），便于快速生效

## 问题 7：GitHub Pages 自定义域名检查失败

### 可能的原因

1. **DNS 未生效**：等待 DNS 传播（最多 48 小时）
2. **记录值错误**：检查是否输入了正确的 GitHub 用户名
3. **记录类型错误**：确保使用 CNAME 或 A 记录
4. **TTL 设置过长**：建议设置为 600（10 分钟）

### 解决方法

1. 使用在线工具验证 DNS 解析是否正确
2. 检查 GitHub 用户名是否正确
3. 等待一段时间后重试
4. 清除本地 DNS 缓存

## 问题 8：如何找到我的 GitHub 用户名

### 方法 1：查看 GitHub 个人资料

1. 登录 GitHub
2. 点击右上角头像
3. 查看用户名（在个人资料页面）

### 方法 2：查看仓库 URL

如果您的仓库 URL 是：
```
https://github.com/BBplayer2021/WangLinJie-Lab
```

那么用户名就是：`BBplayer2021`

### 方法 3：查看 GitHub Pages URL

如果您的 GitHub Pages URL 是：
```
https://bbplayer2021.github.io/WangLinJie-Lab
```

那么用户名就是：`bbplayer2021`

## 总结

**关于大小写**：
- ✅ DNS 不区分大小写
- ✅ 输入大写或小写都可以
- ✅ 系统自动转换为小写是正常现象
- ✅ **不会影响** DNS 解析和网站访问

**您的配置**：
- 记录值：`bbplayer2021.github.io`（小写显示）
- 这是**完全正确**的，可以正常使用！

