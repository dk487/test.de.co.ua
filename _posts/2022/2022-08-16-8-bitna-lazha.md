---
title: 8-бітна лажа
date: 2022-08-16 23:21:42 +03:00
---

Привіт світ. Я ще не спая́в собі [драбинко́ву мережу][1] для саморобного ЦАП, але знайшов гра́блі з зовсім неочікуваного боку.

Власне, що за звук я хочу відтворити? Частота не більше 22050, один канал (моно) і лише 8 біт. Більше ніж 8 біт робити немає сенсу, у мене є тільки дешеві резистори, а у них точність «гуляє» настільки, щоб більше 8 біт і не намага́тися. 

Вирішив я підготувати тестовий WAV-файл з 8-бітним звуком. І тут раптом виявилося, що у ме́не це не виходить. Воно, бляха, шипить і тріщи́ть.

[Джерельний код моїх експериментів][2].

[Демонстрація: звук на YouTube][3].

[1]: /2022/08/14/samorobnyi-dac.html
[2]: https://github.com/kastaneda/arduino_sandbox/tree/master/speaking
[3]: https://www.youtube.com/watch?v=-I6BUfxane0