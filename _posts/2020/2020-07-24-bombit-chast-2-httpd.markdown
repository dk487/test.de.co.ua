---
title: 'Бомбит, часть 2: httpd'
date: 2020-07-24 07:33:00 +03:00
lang: ru
---

А ещё у меня бомбит от того, что на фронте нынче принято веб-сервер таскать с собой и запускать по команде кодера. У меня на локалхосте порты 8000, 8080 и 8888 всегда заняты совершенно разными приложениями. Вот и нахуя я всегда настраивал mass virtual hosting, и systemd-resolved, или вообще руками /etc/hosts писал? Надо было всё в один localhost:8080 пихать.

Как ни странно, backend тоже бывает заражён этим. Symfony тоже этой хуйнёй страдает, но не так настойчиво. Всё-таки раз юзаешь похапе, то и апач ставить должен уметь, гыгы.

Отдельно можно упомянуть докер-контейнеры, и пожалеть их, потому что там действительно иначе никак. Но и к ним можно reverse proxy кинуть.
