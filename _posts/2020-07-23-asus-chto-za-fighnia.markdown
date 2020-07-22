---
title: Asus, что за фигня
date: 2020-07-23 01:04:00 +03:00
---

Здравствуй, дорогой как-бы-твиттер, я напишу сюда какую-то хуйню.

У меня есть прекрасный роутер Asus RT-AC58U, а у него штатная прошивка версии 3.0.0.4.382_52134 и штатная веб-морда. Сегодня зашёл я понажимать всякие кнопки от нехуй делать, и заодно проверить, не вышла ли новая прошивка. Нажимаю на Check и…

![screen_01-08-45.png](/uploads/screen_01-08-45.png)

> The router cannot connect to ASUS server to check for the firmware update. After reconnecting to the Internet, go back to this page and click Check to check for the latest firmware updates. 

Ух ты. Подозрительная хуйня.

Наверное, надо проверить руками. Иду на [сайт][1] [производителя][2], ищу прошивки. Нахожу новую версию. [Качаю][3]. Машинально проверяю MD5.

```
gray@carmilhan:~/inbox$ md5sum FW_RT_AC58U_300438252243.zip 
8aa3563d6985b0b0e0f91961e26c8ecf  FW_RT_AC58U_300438252243.zip
```

Смотрю ещё раз [на сайт][2].

![screen_01-18-49.png](/uploads/screen_01-18-49.png)

8aa3563d6985b0b0e0f91961e26c8ecf != 6b9f764a970313d19063404eb6c74dc8. Assertion failed. Tadadadam. Отлично, блядь, просто отлично.

Итак, хосты Asus по прекрасному https дают мне файл с одним md5 и показывают страничку, на которой написан совсем другой md5. Вероятнее всего, они просто криво писали changelog, но формально нельзя исключать, что их взломали, муахаха.

Теперь мне как-то стрёмно ставить эту прошивку.

[1]: https://www.asus.com/Networking/RT-AC58U/HelpDesk_BIOS/
[2]: https://www.asus.com/ua-ua/Networking/RT-AC58U/HelpDesk_BIOS/
[3]: https://dlcdnets.asus.com/pub/ASUS/wireless/RT-AC58U/FW_RT_AC58U_300438252243.zip