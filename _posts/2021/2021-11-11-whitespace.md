---
title: Контроль над white-space
date: 2021-11-11 14:54:27 +02:00
---

Деякі редактори лишають пробі́ли в кінці рядка, або не ставлять символ нового рядка в кінці файлу. Дрібниці, що бісять.

Ось моя відповідь:

```sh
for file in $(git grep --cached -Il '')
do
  sed -i 's/\s*$//' $file
  [ -n "$(tail -c1 $file)" ] && echo "" >> $file
done
```

Джерело натхнення і додаткові подробиці:

<div lang="en" markdown=1>
 - [How to list all text (non-binary) files in a git repository?][1]
 - [How to remove trailing whitespaces with sed?][2]
 - [How to add a newline to the end of a file?][3]
</div>

Також дякую пану [@diggya][4].

[1]: https://stackoverflow.com/a/24350112
[2]: https://stackoverflow.com/a/4438318
[3]: https://unix.stackexchange.com/a/263965
[4]: https://twitter.com/diggya/

Обговорення у Twitter: <https://twitter.com/kastaneda/status/1458782553989685251>
