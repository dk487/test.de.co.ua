---
title: Тестовий сайт
---

Тестовий сайт
=============

Всім привіт.

Ви можете знати мене у соцмережах як [@kastaneda][1]{:rel="me"} у&nbsp;Twitter, [@dk487@mastodon.social][2]{:rel="me"} у&nbsp;Mastodon та [@dk487.bsky.social][3]{:rel="me"} у&nbsp;BlueSky.

Мій особистий сайт це [kastaneda.kiev.ua](https://kastaneda.kiev.ua/), ну або принаймні він там колись буде.

А тут у мене такий [тестовий сайт][4], щоб писати сюди всяку фігню́.

{% assign prev_year = false %}
{% assign posts = site.posts | where_exp: "item", "item.rss_only != true" %}
{% for post in posts %}
{% assign post_year = post.date | date: "%Y" %}
{% if prev_year != post_year %}

## {{ post_year }}

{% endif %}
- [{% if post.draft %}[DRAFT]{% else %}{{ post.date | date: "%Y-%m-%d" }}:{% endif %} {{ post.title }}]({{ post.url }}){% if post.title_lang %}{:lang="{{ post.title_lang }}"}{% endif %}

  {{ post.excerpt }}
{% assign prev_year = post_year %}
{% endfor %}

[1]: https://twitter.com/kastaneda
[2]: https://mastodon.social/@dk487
[3]: https://bsky.app/profile/dk487.bsky.social
[4]: /2021/07/02/why-test.html
