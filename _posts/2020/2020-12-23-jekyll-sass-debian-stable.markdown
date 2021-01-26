---
title: Jekyll, SASS, Debian stable
date: 2020-12-23 07:01:00 +02:00
---

От блін.

На ноуті Debian Sid і там нова версія Jekyll, а на сервері Buster, і там трохи старіша версія.

І це капець. SASS в цих версіях дуже різний. Та навіть парсер Markdown різний.

Треба побудувати процес збірки нормальний, робити білд в окремому контейнері та все таке.

Upd.: поки що я вирішив [замінити backslash у кінці рядку на br][1], бо так краще [з точки зору сумісності][2] і це мені не дуже ріже око.

[1]: https://github.com/kastaneda/kastaneda.kiev.ua/commit/b6b73ab484c7cdeab9caf6c97c4f58b9fd8069d3
[2]: https://www.markdownguide.org/basic-syntax/#line-break-best-practices
