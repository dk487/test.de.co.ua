---
title: Firmata + Bluetooth
date: 2022-09-20 22:47:08 +03:00
---

Запустив сабж.

Крім [двох нових модулів], маю старий HC-06. На відміну від нових, старий працює. От з ним StandardFirmataPlus і злетіла.

Модуль жере під час роботи десь 30–40 мА, окрім самого Arduino (і той ще 20). З таким рівнем споживання не зробиш пристрій, що місяцями працює від батарейок. Але взагалі щось якось робити з цим можна.

А ще прошивка у мого старого HC-06, схоже, крім `AT+NAME` не знає жодної команди. Тому я на ньому не можу змінити pin-код зі стандартного 1234 на щось інше; а саме сумне, що його швидкість там завжди 9600.

Та до біса. Я додав всього кілька рядків коду до  StandardFirmataPlus, і все запрацювало. Це ж кльово!

[1]: /2022/09/19/bluetooth.html