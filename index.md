---
title: Тестовий сайт
---

Тестовий сайт
=============

Всім привіт, я [@kastaneda][1], а це в мене такий [тестовий сайт][2], щоб писати сюди всяку фігню.

{% assign prev_year = false %}
{% for post in site.posts %}
{% assign post_year = post.date | date: "%Y" %}
{% if prev_year != post_year %}

## {{ post_year }}

{% endif %}
- [{{ post.date | date: "%Y-%m-%d" }}: {{ post.title }}]({{ post.url }})
{% assign prev_year = post_year %}
{% endfor %}

[1]: https://twitter.com/kastaneda
[2]: /2021/07/02/why-test.html
