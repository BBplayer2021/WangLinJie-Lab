# 王林杰教授课题组网站

## 网站结构

本网站使用 Jekyll 静态网站生成器构建，参考了 GU LAB 网站的设计思路。

### 主要页面

- **首页** (`index.markdown`) - 展示课题组核心信息、最新动态和导师寄语
- **研究方向** (`research.markdown`) - 详细介绍三个研究方向
- **发表论文** (`publications.markdown`) - 代表性学术论文和专著
- **新闻动态** (`news.markdown`) - 自动展示所有新闻文章
- **团队成员** (`people.markdown`) - 课题组人员信息
- **导师介绍** (`about.markdown`) - 王林杰教授的详细介绍
- **加入我们** (`join-us.markdown`) - 申请加入课题组的信息
- **联系方式** (`contact.markdown`) - 联系方式和地址信息

### 新闻文章

新闻文章存放在 `_posts/` 目录，按日期和分类组织：
- 成果速递
- 项目启动
- 论文发表
- 会议活动
- 奖项荣誉

### 静态资源

- `assets/images/` - 图片资源
- `_site/` - Jekyll 生成的静态 HTML 文件（部署时使用）

## 本地开发

```bash
# 安装依赖
bundle install

# 启动本地服务器
bundle exec jekyll serve

# 访问 http://localhost:4000
```

## 部署

网站可以部署到：
- GitHub Pages
- Netlify
- Vercel
- 或其他静态网站托管服务

## 更新内容

1. **更新新闻**：在 `_posts/` 目录添加新的 Markdown 文件
2. **更新页面**：直接编辑对应的 `.markdown` 文件
3. **更新配置**：编辑 `_config.yml` 文件

## 参考网站

本网站的设计参考了 [GU LAB 网站](https://www.gulab.info/) 的结构和设计思路。

