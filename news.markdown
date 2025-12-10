---
layout: page
title: 新闻动态
permalink: /news/
---

# 新闻动态

## 最新动态

{% for post in site.posts limit:10 %}
### {% unless post.show_date == false %}{% if post.date %}{{ post.date | date: "%Y年%m月%d日" }} - {% endif %}{% endunless %}{{ post.title }}

{{ post.excerpt | default: post.content | strip_html | truncatewords: 50 }}

[阅读全文 →]({{ post.url }})

---
{% endfor %}

## 按类别浏览

### 成果速递
{% for post in site.posts %}
  {% if post.categories contains "成果速递" %}
- [{{ post.title }}]({{ post.url }}){% unless post.show_date == false %}{% if post.date %} - {{ post.date | date: "%Y年%m月%d日" }}{% endif %}{% endunless %}
  {% endif %}
{% endfor %}

### 项目启动
{% for post in site.posts %}
  {% if post.categories contains "项目启动" %}
- [{{ post.title }}]({{ post.url }}){% unless post.show_date == false %}{% if post.date %} - {{ post.date | date: "%Y年%m月%d日" }}{% endif %}{% endunless %}
  {% endif %}
{% endfor %}

### 论文发表
{% for post in site.posts %}
  {% if post.categories contains "论文发表" %}
- [{{ post.title }}]({{ post.url }})
  {% endif %}
{% endfor %}

### 会议活动
{% for post in site.posts %}
  {% if post.categories contains "会议活动" %}
- [{{ post.title }}]({{ post.url }}){% unless post.show_date == false %}{% if post.date %} - {{ post.date | date: "%Y年%m月%d日" }}{% endif %}{% endunless %}
  {% endif %}
{% endfor %}

### 奖项荣誉
{% for post in site.posts %}
  {% if post.categories contains "奖项荣誉" %}
- [{{ post.title }}]({{ post.url }}){% unless post.show_date == false %}{% if post.date %} - {{ post.date | date: "%Y年%m月%d日" }}{% endif %}{% endunless %}
  {% endif %}
{% endfor %}

---

*更多新闻动态，请关注我们的最新更新。*

