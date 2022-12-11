---
title: Погодна станція №2
date: 2022-12-11 07:08:34 +02:00
---

Так склалося, що [перша погодна станція][2] в мене зветься `board02`, а друга `board03`. Тому що ім'я `board01` я залишив для [схеми з кнопкою][1].

Електрична схема та сама, що і у першій погодній станції. Але візуально різниця є.

До речі, це та сама плата NodeMCU і та сама хитра широка макетна плата, на якій була зібрана схема з кнопкою. Подивіться, в неї не по 5, а по 6 контактів. Також на фото можна бачити кілька з'єднань, які частково ховаються під модулем NodeMCU.

<p markdown=0>
  <a href="/uploads/board03_base.webp" >
    <picture>
      <source srcset="/uploads/board03_base.webp" type="image/webp">
      <img src="/uploads/board03_base_small.jog" alt="На фото: макетна плата з дротами">
    </picture>
  </a>
</p>

І на цю широку макетку чудово стає NodeMCU, лишаючи один ряд дірочок назовні.

<p markdown=0>
  <a href="/uploads/board03.webp" >
    <picture>
      <source srcset="/uploads/board03.webp" type="image/webp">
      <img src="/uploads/board03_small.jog" alt="На фото: макетна плата з погодною станцією у зборі">
    </picture>
  </a>
</p>

Трохи оновив код, [поклав його на GitHub][3].

[1]: /2022/11/14/micropython-on-esp8266.html
[2]: /2022/12/04/weather-station.html
[3]: https://github.com/kastaneda/mpy_sandbox/tree/master/weather
