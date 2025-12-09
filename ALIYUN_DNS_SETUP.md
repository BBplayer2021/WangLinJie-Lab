# 阿里云域名 DNS 解析设置指南

## 域名信息

- **域名**：fishandgoat.cloud
- **DNS 服务器**：dns3.hichina.com, dns4.hichina.com（阿里云默认 DNS）
- **注册商**：阿里云

## 设置 DNS 解析步骤

### 方法一：在阿里云控制台设置（推荐）

#### 步骤 1：进入域名解析设置

1. 登录 [阿里云控制台](https://ecs.console.aliyun.com/)
2. 在顶部搜索框输入 **"域名"** 或 **"DNS"**
3. 点击 **"域名"** → **"域名解析 DNS"**
4. 或者直接访问：https://dns.console.aliyun.com/

#### 步骤 2：找到您的域名

1. 在域名列表中，找到 **fishandgoat.cloud**
2. 点击域名名称或右侧的 **"解析设置"** 按钮

#### 步骤 3：添加 DNS 记录

点击 **"添加记录"** 按钮，添加以下记录：

**记录 1：主域名（@）**

```
记录类型：CNAME
主机记录：@
记录值：bbplayer2021.github.io（或 BBplayer2021.github.io，DNS 会自动转换为小写）
TTL：600（或默认值）
```

**注意**：DNS 系统不区分大小写，输入 `BBplayer2021.github.io` 或 `bbplayer2021.github.io` 都可以，系统会自动转换为小写。这**不会影响** DNS 解析。

**记录 2：www 子域名**

```
记录类型：CNAME
主机记录：www
记录值：bbplayer2021.github.io（或 BBplayer2021.github.io）
TTL：600（或默认值）
```

**或者使用 A 记录（如果 CNAME 不工作）：**

**记录 1：主域名（@）**

```
记录类型：A
主机记录：@
记录值：185.199.108.153
TTL：600
```

**记录 2-4：主域名（@）的其他 IP**

```
记录类型：A
主机记录：@
记录值：185.199.109.153
TTL：600
```

```
记录类型：A
主机记录：@
记录值：185.199.110.153
TTL：600
```

```
记录类型：A
主机记录：@
记录值：185.199.111.153
TTL：600
```

**记录 5：www 子域名（使用 CNAME）**

```
记录类型：CNAME
主机记录：www
记录值：your-username.github.io
TTL：600
```

### 方法二：通过域名管理页面

1. 登录阿里云控制台
2. 进入 **"产品与服务"** → **"域名"** → **"域名列表"**
3. 找到 **fishandgoat.cloud**，点击 **"解析"** 或 **"解析设置"**
4. 按照上述步骤添加记录

## 详细操作截图说明

### 添加记录界面说明

在添加记录页面，您会看到以下字段：

- **记录类型**：选择 `CNAME` 或 `A`
- **主机记录**：
  - `@` 表示主域名（fishandgoat.cloud）
  - `www` 表示 www.fishandgoat.cloud
  - `*` 表示所有子域名（可选）
- **记录值**：
  - CNAME：`your-username.github.io`
  - A 记录：GitHub Pages 的 IP 地址
- **TTL**：600（10分钟）或使用默认值

## 推荐配置

### 方案 A：使用 CNAME（推荐 ⭐）

**优点**：
- ✅ 配置简单
- ✅ GitHub 更新 IP 时自动生效
- ✅ 一条记录即可

**配置**：
```
@    CNAME    your-username.github.io    600
www  CNAME    your-username.github.io    600
```

### 方案 B：使用 A 记录

**优点**：
- ✅ 更快的解析速度
- ✅ 某些情况下更稳定

**缺点**：
- ❌ 需要添加 4 条 A 记录
- ❌ GitHub 更新 IP 时需要手动更新

**配置**：
```
@    A    185.199.108.153    600
@    A    185.199.109.153    600
@    A    185.199.110.153    600
@    A    185.199.111.153    600
www  CNAME  your-username.github.io    600
```

## 重要提示

### 1. 替换 GitHub 用户名

将 `your-username` 替换为您的实际 GitHub 用户名。

例如，如果您的 GitHub 用户名是 `BBplayer2021`，则记录值应该是：
- `BBplayer2021.github.io`

### 2. 检查现有记录

在添加新记录前，检查是否已有冲突的记录：
- 如果有旧的 `@` 或 `www` 记录，需要先删除或修改
- 确保没有重复的记录

### 3. DNS 传播时间

- **通常**：几分钟到几小时
- **最长**：最多 48 小时
- **检查方法**：使用 `nslookup` 或在线 DNS 检查工具

## 验证 DNS 配置

### 方法 1：使用命令行

```bash
# Windows PowerShell
nslookup fishandgoat.cloud

# 或
nslookup fishandgoat.cloud 8.8.8.8
```

### 方法 2：在线工具

访问以下网站检查 DNS 解析：
- https://www.whatsmydns.net/
- https://dnschecker.org/
- https://tool.chinaz.com/dns/

### 方法 3：在 GitHub 验证

1. 在 GitHub 仓库中，进入 **Settings** → **Pages**
2. 在 **Custom domain** 部分，应该显示：
   - ✅ "DNS check successful"（DNS 检查成功）
   - ✅ 绿色勾号

## 常见问题

### 1. 找不到"解析设置"按钮

**解决**：
- 确保您有域名管理权限
- 尝试刷新页面
- 使用直接链接：https://dns.console.aliyun.com/

### 2. 无法添加 CNAME 记录

**原因**：根域名（@）不能使用 CNAME（某些 DNS 提供商限制）

**解决**：使用 A 记录代替

### 3. DNS 解析不生效

**检查**：
1. 记录是否正确添加
2. TTL 是否设置合理（建议 600）
3. 等待 DNS 传播（最多 48 小时）
4. 清除本地 DNS 缓存：
   ```bash
   # Windows
   ipconfig /flushdns
   ```

### 4. 如何找到我的 GitHub 用户名

1. 登录 GitHub
2. 点击右上角头像
3. 查看用户名（在个人资料页面）

或者查看仓库 URL：
- 如果仓库 URL 是 `https://github.com/BBplayer2021/WangLinJie-Lab`
- 那么用户名就是 `BBplayer2021`

## 完整配置示例

假设您的 GitHub 用户名是 `BBplayer2021`，配置如下：

### 在阿里云 DNS 解析中添加：

| 记录类型 | 主机记录 | 记录值 | TTL |
|---------|---------|--------|-----|
| CNAME | @ | bbplayer2021.github.io | 600 |
| CNAME | www | bbplayer2021.github.io | 600 |

**重要说明**：
- DNS 系统**不区分大小写**
- 输入 `BBplayer2021.github.io` 或 `bbplayer2021.github.io` 都可以
- 系统会自动转换为小写显示（这是正常现象）
- **不会影响** DNS 解析和网站访问

### 在 GitHub 中配置：

1. 确保 `CNAME` 文件包含：`fishandgoat.cloud`
2. 在 **Settings** → **Pages** → **Custom domain** 中输入：`fishandgoat.cloud`
3. 勾选 **"Enforce HTTPS"**

## 配置完成后的检查清单

- [ ] DNS 记录已添加（@ 和 www）
- [ ] 记录值正确（GitHub 用户名.github.io）
- [ ] GitHub Pages 中已配置自定义域名
- [ ] `CNAME` 文件已提交到仓库
- [ ] 等待 DNS 传播（几分钟到几小时）
- [ ] 使用在线工具验证 DNS 解析
- [ ] 访问 https://fishandgoat.cloud 测试

## 需要帮助？

如果遇到问题：
1. 检查 DNS 记录是否正确
2. 验证 GitHub 用户名是否正确
3. 查看 GitHub Pages 设置中的错误提示
4. 等待 DNS 传播完成

---

**提示**：配置完成后，通常几分钟内就会生效。如果超过 24 小时仍未生效，请检查配置是否正确。

