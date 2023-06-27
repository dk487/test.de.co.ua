---
title: KeePassXC, Qt та DPI
date: 2023-06-27 23:02:05 +03:00
---

Перестав працювати KeePassXC. Вилітає segmentation fault з якимись дивними матюками на норвезькій тролячій мові.

```
qt.qpa.xcb: xcb_shm_create_segment() can't be called for size 17178820624, maximumallowed size is 4294967295
QWidget::paintEngine: Should no longer be called
QPainter::begin: Paint device returned engine == 0, type: 1
QWidget::paintEngine: Should no longer be called
QPainter::begin: Paint device returned engine == 0, type: 1
QPainter::begin: Paint device returned engine == 0, type: 1
QPainter::pen: Painter not active
QPainter::setPen: Painter not active
QPainter::setPen: Painter not active
QWidget::paintEngine: Should no longer be called
...
```

Але KeePassXC працює на тому самому ноуті під іншим користувачем.

В результаті подальших досліджень виявилося, що ця лажа пов'язана зі зміною DPI. Якщо в xrdb змінити Xft.dpi з 144 (як у мене зараз) на 120 (як було раніше), то все працює.

Нагуглив щось, що допомагає зупинити цю bad magic в останніх версіях Qt:

```sh
QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough keepassxc
```

Гей Trolltech, нє ну ви там нормальні?
