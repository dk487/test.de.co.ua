---
title: Тестовый сайт
---

Ну, короче, тут всякая фигня.

- [Как сделать такой сайт](tools.html)

Что тут нового
------------

{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }})
{% endfor %}
