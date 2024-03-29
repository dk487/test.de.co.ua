---
title: Наступна пого́дна станція
date: 2023-01-08 22:38:41 +02:00
mtime: 2023-01-08 22:38:51 +02:00
opengraph: uploads/wemos_d1_mini_og.jpg
---

Я вже писав, що зробив собі з ESP8266 та BMP280 маленьку [пого́дну станцію][1], а потім [ще одну][2]. Зараз експерименту́ю з третьою. Вона ще не завершена, але вже якось працює.

Перші дві станції, попри деяку різницю у зовнішньому вигляді, схематично та софтва́рно були однаковими. Третя відрізняється.

Є різниця у платі з ESP8266. Попередні дві використовували NodeMCU v3, а в цій я використовую WeMos D1 mini. Це маленька плата, її можна поставити на крихітну маке́тку SYB-170. Купив їх декілька по $1.59 за штуку, наче норм.

<p markdown=0>
  <a href="/uploads/wemos_d1_mini.webp" >
    <picture>
      <source srcset="/uploads/wemos_d1_mini.webp" type="image/webp">
      <img src="/uploads/wemos_d1_mini_small.jpg" alt="На фото: плата WeMos D1 mini і монета для масштабу">
    </picture>
  </a>
</p>

Є різниця у термо́метрі. Датчик BMP280 це ж, в першу чергу, цифровий барометр. Барометр мене наразі цікавить мало. Я вирішив спробувати DS18B20, він дешевше і простіше, хоча точність в нього посере́дня. Ще в нього зручни́й корпус TO-92.

![Маке́тна плата з цифровим термо́метром DS18B20 та WeMos D1 mini](/uploads/board04.png)

І, нарешті, є радикальна різниця в живленні. Попередні дві живляться через USB від чого попа́ло (від блока живлення, наприклад). Ця станція живиться від літієвого акумулятора формату 18650, а саме NCR18650B. Номінальна напруга акумулятора 3.7&nbsp;В, номінальна ємність 3700&nbsp;mAh.

Здається, 3.7&nbsp;В це дуже близько до напруги 3.3&nbsp;В, якими живиться ESP8266. Чи можна подати прямо на контакт 3V3? Ніт. Фактична напруга повністю зарядженого літієвого акумулятора такого типу складає близько 4.2&nbsp;В, що забагато. (І все ще менше того, що можна подати на контакт 5V). Та головна проблема, що (згідно з документацією) ESP8266 дуже примхлива, потребує стабільної вхідної напруги. Може й не згори́ть, але Wi-Fi працюватиме гірше.

Тому мені потрібен якийсь стабілізатор живлення. Я спробував використати LDO регулятор напруги HT7333-1. Можливо, то не найкращий вибір, але з наявних у мене альтернатив був лише AMS1117, який мені здався менш підходящим для такої задачі.

![Схема підключення акумулятора 18650 та плати WeMos D1 mini через HT7333](/uploads/board04_power.png)

HT7333-1, згідно зі специфікацією, потребує конденсаторів на вході та виході. Я поки що поліни́вся захищати вхід. На виході в мене стоїть керамічний конденсатор на 0.1&nbsp;µF та електроліти́чний конденсатор на 10&nbsp;µF, як рекомендує datasheet. (По темі: посилання на тред в твітері з [обговоренням стабілізаторів][3]).

Наче працює.

Зізна́юся, HT7333-1 у мене знайшовся лише в корпусі SOT89-3. Мені б він ідеально підійшов у корпусі TO-92. Але HT7333-1 у потрібному корпусі приїде з AliExpress колись у далекому світлому майбутньому. Зараз є тільки SOT89.

Так а що робити з цим SOT89 такому чайнику як я? Якось зі страше́нними матюками я тримтя́чими руками припаяв до його крихітних ніжок три мідні проволочки, витягнуті з витої пари. Дивно, але воно не згоріло. Фото результату викладати соромно.

Так. Ну і на оста́нок, є деяка різниця у софті́. Там такий самий MicroPython і [схожа прошивка][4], тільки вже для іншого датчику.


Трохи арифметики
================

Режим сну у цієї станції триває не 1&nbsp;хвилину, а вже цілих 5. Навіть 5 хвилин це досить часто, це 288 вимірювань на добу. Для загальної оцінки можна було б вимірювати раз на годину і все одно бачити динаміку.

Тривалість активної роботи модуля при кожному прокида́нні, судячи по світлодіо́дній індикації, десь приблизно 4&nbsp;секунди. (Варто буде якось виміряти це точніше). За кожну годину часу станція проводить 48&nbsp;секунд в активному режимі. А за добу 1152&nbsp;секунди (0.32&nbsp;години) активного режиму.

Струм в активному режимі до 200&nbsp;mA. Буду рахувати по верхній межі.

Струмом в режимі deep sleep знехтую, він там поря́дку 10&nbsp;µA. (От якби станція прокидалася раз на 5 годин, то був би сенс його враховувати). Також проігнору́ю струм, що споживає DS18B20 в режимі спо́кою, він&nbsp;≤&nbsp;1&nbsp;µA.

Номінальна ємність нового акумулятора 3700&nbsp;mAh. Фактична ємність, звісно, менша і з часом стає все меншою. Також не буду чіпати питання захисту акумулятора від надто глибокого розряду.

В ідеальному світі, ідеальні 3700&nbsp;mAh — це 3700&nbsp;годин роботи при струмі 1&nbsp;mA, або 1&nbsp;година при струмі 3.7&nbsp;A, або 18.5&nbsp;годин при нашому струмі 200&nbsp;mA. В реальності складніше, але порядок цифр приблизно має збігатися. Один мій друг казав, що не дуже свіжого 18650 для ESP8266 в безперервному активному режимі вистачає десь на половину дня. Тож наче правдоподібно.

Окей. Значить, якщо моя погодна станція працює 0.32&nbsp;години активного режиму на добу, то такого акумулятора має їй вистачити на 57.8&nbsp;діб. За цей час вона зробить приблизно 16&nbsp;тисяч вимірювань. А якщо збільшити періоди сну, то і загальний час роботи збільшиться.

Така цікава арифметика.


Мої наступні плани
==================

Кілька днів подивлюся, як працюватиме ця станція. Зокрема, спостеріга́тиму за напругою.

Акумулятор 18650 я заряджа́в від контро́лера заряду на базі TP4056, що живиться від USB або 5&nbsp;В. Наразі в цій схемі той контролер відсутній. У майбутньому я його туди плану́ю підключити; це дасть можливість заряджати акумулятор «на ходу», а ще дасть захист від глибокого розряду.

Ще в ме́не є маленька сонячна батарея. Зовсім маленька. (Звісно, я обрав _найкращу_ пору року для експериме́нтів з нею). Під прямими променями сонця вона дає струм 60&nbsp;mA при напрузі трошки більше 6&nbsp;В. В описі цієї батареї заявлено, що струм може бути вп'ятеро більший. Ну, може влітку.

Так от, програма-максимум щодо цієї станції у ме́не така: підключити сонячну батарею до входу контро́лера на TP4056. Можливо, в мене нарешті вийде побудувати повністю автономну погодну станцію, що піджи́влює акумулятор від сонця.


Що ще почитати
==============

Дуже рекоменду́ю [одну цікаву статтю][5] про систему з ESP, що живиться від 18650 і живе тривалий час. Там рівень схемотехніки незрівня́нно вищій, ніж у ме́не. Для ме́не ця стаття була джерелом натхнення і деяких ідей.


[1]: /2022/12/04/weather-station.html
[2]: /2022/12/11/weather-station-2.html
[3]: https://twitter.com/kastaneda/status/1611884991515971588
[4]: https://github.com/kastaneda/mpy_sandbox/blob/master/weather_DS18B20/main.py
[5]: https://blog.zakkemble.net/mail-notifier-wifi-edition/
