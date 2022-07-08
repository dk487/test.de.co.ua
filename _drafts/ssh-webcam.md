---
title: SSH та веб-камери
placeholder: here
---

Продовжую [тему про SSH][1]. Сьогодні я розкажу дуже просту і банальна штуку: як зазирнути в веб-камеру, підключену до віддаленого хоста.


## Базовий доступ

Щоб локально подивитися на веб-камеру, я використовую маленьку консольну програму `fswebcam`. На Debian чи Ubuntu ставиться через `sudo apt install fswebcam`.

За замовчанням вона відкриває першу камеру (тобто `/dev/video0`) і використовує найменший розмір зображення (це легко змінити), а ще ліпить дурацький банер (його легко вимкнути).

Локально спробувати `fswebcam` можна якось так:

```sh
fswebcam --resolution 640x480 --no-banner --save webcam-snapshot.jpg
```

Вже непогано, чи не так? Збережений файл можна витягти через `scp`. Але це не все.


## Потокова версія

Для перегляду картинок є дуже багато різних програм. Я найчастіше використовую `feh` — легку, швидку і без зайвих залежностей. Ставиться, очікувано, через `sudo apt install feh`. Дивіться, що з нею можна зробити:

```sh
fswebcam --resolution 1280x720 - | feh -
```

Тут `fswebcam` пише знімок у стандартний потік виводу (stdout), а `feh` читає стандартний потік вводу (stdin), і все працює без тимчасових файлів. Передавати JPEG через потоки цілком нормально. (Ще `fswebcam` в stderr пише повідомлення типу «Opening /dev/video0», і їм це перенаправлення не заважає).


## Збираємо все докупи

Вхідний та вихідний потоки у команди `ssh` теж можуть бути бінарні. Ймовірно, ви бачили команди типу `tar zcf - some_dir/ | ssh otherhost tar zxf -` та їм подібні.

Тож… Ось воно:

```sh
ssh foohost fswebcam --resolution 1280x720 - | feh -
```

При всій простоті, це буває дуже зручно.


## Raspberry Pi

Все вищесказане відносилось до звичайних веб-камер, підключених по USB.

Якщо у вас є Raspberry Pi, до якої пласким шлейфом через спеціальний інтерфейс підключена її «рідна» камера, то треба використовувати інші програми, наприклад `raspistill`.

```sh
ssh rpi0 raspistill -n -o - | feh -
```

В мене є окремий [пост про камеру до Raspberry Pi][2].

[1]: /fixme
[2]: /2021/07/08/rpi-camera.html