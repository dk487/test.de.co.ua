---
title: Тестовый сайт
---

Ну, короче, тут всякая фигня.

Latest news
-----------

{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }})
{% endfor %}
