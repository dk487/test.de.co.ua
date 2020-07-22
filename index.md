---
title: Тестовый сайт
---

{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }})
{% endfor %}

---

[RSS](/rss.xml)
