---
title: Зображення для OpenGraph
date: 2022-07-16 11:52:01 +03:00
mtime: 2022-07-21 20:32:24 +03:00
---

Спробував прикрути́ти ну хоч якусь «заглу́шку» для сумісності з OpenGraph.

Для тих, хто не в темі: це коли постиш посилання на свій улюблений сайт десь в Facebook, чи у Twitter, чи навіть у Skype і воно замість «просто посилання» у вигляді тексту з підкресленням раптом відображається красивим прямокутним блоком з картинками, якимись написами, таке собі preview.


## Як це виглядає

Наприклад, [ось цей пост][1] так виглядає у твітері:

![Знімок екрану: пост у Twitter з посиланням на мій пост](/uploads/opengraph-twitter.png)

А так він виглядає у Skype:

![Знімок екрану: повідомлення у Skype з посиланням на мій пост](/uploads/opengraph-skype.png)

Тут ви можете помітити, що у мене і Skype, і Twitter використовують темну тему оформлення.


## Моя картинка-заставка

Як бачите, моя [картинка для OpenGraph][2] дуже примітивна. Власне, я не малював її, а _написав_, бо джерело цієї картинки у PNG — це маленький, [руками написаний SVG][3], у якому на сірому тлі посередині розміщена вже існуюча векторна іко́нка сайту і нічого більше немає.

Ладно. Взагалі-то я не люблю OpenGraph. Дуже непрозора, непередбачувана штука. Ніколи не знаєш, в якому місці воно злама́ється наступного разу.

Зокрема, Twitter чомусь не хотів завантажувати зображення з мого сайту по HTTPS. Якщо для значення `og:image` HTTPS замінити на HTTP, то все стає нормально. Сама сторінка по HTTPS для нього не створює проблем, проблеми тільки з зображенням. От же падло.


## Великі плани

Ну ладно, текстові поля́ `og:type` та `og:description` дійсно корисні. Ви можете побачити у Skype чи у твітери заголовок по́сту та невеликий вступний фрагмент тексту ще до того, як перейдете по посила́нню.

А з картинками дещо лажа. Показувати одну і ту саму картинку для всіх пості́в це якось тупо. У мене ж тут не фотобло́ґ, тут переважно текст. Але хочеться, щоб для різних пості́в були різні картинки.

І є у ме́не одна ідея. Що як картинку-заставку робити у SVG з текстом заголовку та якимись псевдовипадковими варіаціями? Ну там, наприклад, кілька кольорових прямокутників на фоні з варіантами розміщення, які залежать від MD5 адреси поста. Такий простенький generative art. А цей SVG автоматично перетворювати на PNG (бо клятий стандарт OpenGraph не підтримує SVG).


## Маленький план

Для окремих постів варто передбачити можливість задати картинку для OpenGraph вручну.

_(Оновлення від 21 липня: ага, наче зробив)._


## Єбану́тий план

В мене дійсно не фотобло́ґ. Але не так щоб рідко бувають фрагменти кода (привіт, вбудо́вана в Jekyll підсві́тка синтаксису). Невеликий фрагмент коду може виглядати дуже красиво, то може його разом з підсві́ткою якось впхнути в OpenGraph?

Крім коду, у пості́ може бути красива математична формула. Зробити OpenGraph з формули — це ж ваще́ бімба! Правда, знадобиться щось типу [MathJax-node][4], і я терпіти не можу Node.js, але заради такої нереальної краси можна потерпі́ти.

[1]: /2022/07/13/kotyky.html
[2]: /opengraph.png
[3]: /opengraph.svg
[4]: https://github.com/mathjax/MathJax-node
