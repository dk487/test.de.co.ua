---
title: Тестовый сайт
---

Ну, короче, тут всякая фигня.

{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }})
{% endfor %}
