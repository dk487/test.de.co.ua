---
title: <code>git commit --date=WTF</code>
title_lang: en
date: 2023-01-14 19:14:01 +02:00
mtime: 2023-01-15 05:52:59 +02:00
---

Гм. Щось дивне коїться.

От я зробив коммі́т [попереднього посту́][1], вказавши при цьому `--date="..."` зі значенням, що мені потрібно. І що я бачу.

```
gray@carmilhan:~/dev/test.de.co.ua$ git log _posts/2023/2023-01-14-make-mtime.md
commit 5914e07d14e159b4bc9f5144f852b2ec3caa175b (HEAD -> master, origin/master, origin/HEAD)
Author: Dmitry Kolesnikov <kastaneda@gmail.com>
Date:   Sat Jan 14 18:46:01 2023 +0200

    New post: make mtime
```

Тут я бачу, що час коммі́та 18:46:01. Це те, що я вказав руками. Окей, так і має бути.

```
gray@carmilhan:~/dev/test.de.co.ua$ git log --pretty=format:%cI _posts/2023/2023-01-14-make-mtime.md
2023-01-14T18:55:27+02:00
```

Тут я бачу, що час коммі́та 18:55:27. Можливо, це був реальний час коммі́та.

Але як? Як таке взагалі можливо в одному і тому са́мому репозита́рії? Дідько, здається я зовсім не знаю Git.

_Оновлення_: так, я читав документацію боком, знайшов першу-ліпшу дату і цим обме́жився. Але для кожного коммі́та є окремо <span lang="en">commiter date</span> та <span lang="en">author date</span> (ох дідько, на́що, на́що?!), відповідно це `%cI` і `%aI`. Так от, мені треба `%aI`.

[1]: /2023/01/14/make-mtime.html
