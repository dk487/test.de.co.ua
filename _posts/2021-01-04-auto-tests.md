---
title: Автоматичні тести
date: 2021-01-04 21:28:50 +02:00
---

Цей сайт має автотести з [Travis CI][1], і зараз вони [фейляться][2].

```
- ./_site/2020/12/02/pro-tsienzuru.html
  *  External link https://twitter.com/hashtag/facebookdisabledme failed: 400 No error
  *  External link https://twitter.com/kastaneda/status/1334147616901369859 failed: 400 No error
- ./_site/2020/12/10/localhost.html
  *  External link https://twitter.com/kastaneda/status/1336860446155010048 failed: 400 No error
- ./_site/2020/12/21/Beth-10.html
  *  External link https://twitter.com/kastaneda/status/1340827654610628613 failed: 400 No error
```

Чомусь Twitter відповідає з кодом 400, і [HTML-Proofer][3] повідомляє про помилку.

Що краще зробити? Проігнорувати посилання на Twitter? Чекати, поки Twitter починиться?
Ігнорувати код 400, який наче і помилка, але насправді ні?

[1]: https://travis-ci.org/
[2]: https://travis-ci.org/github/dk487/test.de.co.ua/builds/751147571
[3]: https://github.com/gjtorikian/html-proofer
