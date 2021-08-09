---
title: Трохи покращив доступність
date: 2021-08-09 17:06:19 +03:00
---

Дійшли руки взятись за мобілку, увімкнути режим читання з екрану і перевірити, як цей сайт звучить. Ох бляха. Все складно.

Терміново напхав в код костилів. Додав кілька `aria-hidden` і наіть одну `aria-label`. Бачу, яке воно все насправді кострубате. Поки що я не готовий посилання у `footer` відформатувати списком, але колись можливо і таке.

Визнаю, у Chrome режим читання наразі працює краще. На жаль, Firefox «нє асіліл» перемикання мови в одній сторінці.

Заодно зробив красиву дату на початку поста, бо давно хотів.


Про наголоси
------------

Для перевірки:

 - Доступність
 - Досту&#769;пність
 - <span aria-label="досту&#769;пність">Доступність

Режим читання з екрану неправильно читає слово «доступність», ставить наголос не там де треба. В цьому пості дохріна слів, які неправильно читаються.

Можна явним чином вказати, де має бути наголос, за допомогою символа `&#769;` і це капець.

Текст з розставленими наголосами виглядає не дуже звично. Не знаю, як візуально сховати символ наголосу. Можна спробувати запхати текст з наголосом в `aria-label`, але це капець у квадраті, дуже незграбне рішення.

Ладно, я ще подумаю, що робити з наголосами.