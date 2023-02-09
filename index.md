---
title: Тестовий сайт
---

Тестовий сайт
=============

Всім привіт, я [@kastaneda][1] (Twitter) / <a rel="me" href="https://mastodon.social/@dk487">@dk487</a> (Mastodon.social), а це в мене такий [тестовий сайт][2], щоб писати сюди всяку фігню́.

{% assign prev_year = false %}
{% for post in site.posts %}
{% assign post_year = post.date | date: "%Y" %}
{% if prev_year != post_year %}

## {{ post_year }}

{% endif %}
- [{% if post.draft %}[DRAFT]{% else %}{{ post.date | date: "%Y-%m-%d" }}:{% endif %} {{ post.title }}]({{ post.url }})

  {{ post.excerpt }}
{% assign prev_year = post_year %}
{% endfor %}

[1]: https://twitter.com/kastaneda
[2]: /2021/07/02/why-test.html
