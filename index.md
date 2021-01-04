---
title: Тестовий сайт
---

Всім привіт, я [@kastaneda][1], а це в мене такий тестовий сайт, щоб писати сюди всяку фігню.

{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }})
{% endfor %}

[1]: https://twitter.com/kastaneda
