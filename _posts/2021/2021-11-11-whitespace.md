---
title: Контроль над <span lang="en">white-space</span>
date: 2021-11-11 14:54:27 +02:00
---

Деякі редактори лишають пробіли в кінці рядка, або не ставлять символ нового рядка в кінці файлу. Дрібниці, що бісить.

Ось моя відповідь:

```sh
for file in $(git grep --cached -Il '')
do
  sed -i 's/\s*$//' $file
  [ -n "$(tail -c1 $file)" ] && echo "" >> $file
done
```

Обговорення у Twitter: <https://twitter.com/kastaneda/status/1458782553989685251>
