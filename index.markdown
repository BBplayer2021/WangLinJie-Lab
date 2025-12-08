---
layout: home
title: "王林杰教授课题组"
subtitle: "基因解码，产业赋能：聚焦山羊、绵羊遗传育种前沿，服务中国现代畜牧业"
---

<div style="text-align: center; margin: 30px 0;">
  <img src="/assets/images/合照2.jpeg" alt="王林杰教授课题组合照" style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
  <p style="margin-top: 10px; color: #666; font-size: 0.9em;">王林杰教授课题组合照</p>
</div>

## 核心标语

**基因解码，产业赋能：聚焦山羊、绵羊遗传育种前沿，服务中国现代畜牧业。**

---

## 导师寄语

<div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin: 30px 0; border-left: 4px solid #007bff;">

我们致力于结合分子生物学、基因组学与传统育种技术，解决羊产业中的关键技术难题。课题组为学生提供前沿的理论学习、充足的科研项目经费和广阔的产业实践平台。

**希望来到这里之后能够继续成长：**  
**批判思考之习惯，钻研刻苦之精神，辩证分析之能力；**  
**追求卓越之信心，积极包容之态度，恪守公正之素养。**

如果您对动物遗传育种充满热情，期待您的加入，共同成长，用科学技术服务国家战略和地方经济。

</div>

---

## Recent Highlights（最新动态）

{% for post in site.posts limit:5 %}
### {{ post.date | date: "%Y年%m月%d日" }} - {% if post.categories %}{{ post.categories[0] }}{% else %}新闻{% endif %}

**{{ post.title }}**

{% if post.excerpt %}{{ post.excerpt }}{% else %}{{ post.content | strip_html | truncatewords: 30 }}{% endif %}

[阅读全文 →]({{ post.url }})

---
{% endfor %}

[查看更多新闻 →](/news/)

---

## 核心优势

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 30px 0;">

<div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; border-top: 3px solid #28a745;">
### 前沿性（Genetics）
利用基因组学、分子生物学等技术解决草食动物遗传育种的关键科学问题（对应代表性论文）。
</div>

<div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; border-top: 3px solid #007bff;">
### 应用性（Industry）
研究成果直接服务于国家和地方的现代农业，有重大科研项目和产业示范基地作为支撑。
</div>

<div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; border-top: 3px solid #ffc107;">
### 成就感（Awards）
课题组在研究和应用方面获得了省部级科技进步奖，证明了成果的质量和价值。
</div>

</div>

---

## 快速导航

- [研究方向](/research/) - 了解我们的研究领域
- [发表论文](/publications/) - 查看代表性成果
- [团队成员](/people/) - 认识课题组
- [加入我们](/join-us/) - 申请加入课题组
- [联系方式](/contact/) - 联系我们
