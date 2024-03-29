---
title: Чому я ніколи не використовую мобільний додаток Приват24
date: 2021-07-09 13:19:05 +03:00
mtime: 2021-11-11 14:35:03 +02:00
---

На смартфоні можна користуватися мобільним додатком «Приват24» або «Приват24 для бізнесу». А ще можна відкрити сайт Приват24 у вікні браузера, наприклад. Буде майже те саме, але з деякими відмінностями.

Люди зазвичай не читають всім відкритий маніфест додатку. Ось він.

> [Цей додаток має доступ до таких даних:][1]
>
> - Пам’ять
>     - читати вміст носія USB
>     - змінення чи видалення вмісту носія USB
> - Фото, медіа-вміст, файли
>     - читати вміст носія USB
>     - змінення чи видалення вмісту носія USB

Це значить, що будь-який файл на вашій SD-картці може бути непомітно викрадений додатком. Ні, я не звинувачую Приват у тому, що вони крадуть файли у користувачів. Просто у них є технічна можливість.

Так, у звичайних людей на телефоні нема документів, є тільки фотки, але не треба недооцінювати важливість фото.

> - Камера
>     - зйомка фото й відео

На ноутбуках веб-камери зазвичай показують активний стан окремим світлодіодом. На мобільнику ви не дізнаєтесь, якщо основна або фронтальна камера тихенько увімкнеться.  Виключенням є моделі телефонів з «висувною» фронтальною камерою, але це рідкість.

Знов-таки, я не звинувачую Приват у тому, що вони нишпорять за своїми клієнтами. Просто вони мають таку технічну можливість. Вони явним чином вимагають цієї можливості.

> - Місцезнаходження
>     - приблизне місцезнаходження (на основі мережі)
>     - точне місцезнаходження (на основі GPS і мережі)

Приватбанк буде знати, де ви живете, де працюєте, де ще (і коли) буваєте. Ви поїхали у відпустку? Пішли у нічний клуб? Відпочиваєте у друзів на дачі? Живете не за адресою прописки? Маєте регулярні маршрути, постійні місця відвідування, патерни поведінки? Все це відомо мобільному додатку, а він передає зібрані дані банку.

І цього разу я не припускаю, а стверджую, що банк знатиме ваше місцезнаходження. Бо в цьому весь сенс використання додатку замість мобільної версії сайту. Служба безпеки Привату про це прямо пише в своїх повідомленнях.

А чого я не знаю, але припускаю — це те, що дані про місцезнаходження можуть потрапити, наприклад, колекторам.

Так, точну інформацію про ваші геодані знає [Google][2], а ще приблизну інформацію знає мобільний оператор. Але я сподіваюся, що дані по GSM дуже приблизні, а ще я поки що бачу, що точні дані з Google наче не потраплять на Петрівку.

> - Історія використання пристрою та додатків
>     - отримувати запущені програми
> - Дані про з’єднання Wi-Fi
>     - переглядати з’єднання Wi-Fi
> - Інше
>     - отримувати дані з Інтернету
>     - переглядати мережеві з’єднання
>     - виконуватися під час запуску
>     - контролювати вібросигнал
>     - читати додані в словник терміни
>     - повний доступ до мережі
>     - не допускати перехід пристрою в режим сну

Ну то вже дрібниці, на фоні даних про місцезнаходження. Але це теж дуже небезпечні і шкідливі дозволи. Таке можна дозволяти лише тим додаткам, розробникам яких ви довіряєте повністю і беззаперечно.


А як має бути?
--------------

Критикувати легко. Можливо, у розробників Привату були поважні причини включити до маніфеста кожен з цих дозволів (і ці причини звали «начальник» та «дедлайн», ггг). Але є дуже фундаментальний принцип: не збирайте приватних даних, без яких можна обійтись.

НБУ вимагає дізнатись про клієнта, яка в нього домашня адреса? Чудово, зробіть в анкеті поле «домашня адреса». Але, як мені відомо, норми НБУ поки що не потребують двох окремих питань «адреса прописки» та «фактична адреса», яку питає кожен перший банк.

Я не знаю, як має бути розроблений мобільний додаток. Але я можу дати пораду щодо банківських сервісів: майте запас часу (тобто не робіть заплановані дії в останній момент), будьте уважні і зберігайте спокій.

Щоразу, коли банк або ще якась поважна установа питає у вас зайву інформацію, варто замислитись, що коїться. Якщо у вас є хоч невеликі сумніви, зупиніться. Спитайте співробітників банку, навіщо їм ця інформація. Спитайте, чи обов'язково відповідати. Відповідь (або навіть _тональність_ відповіді) може вас здивувати: ще хвилину тому вас ввічливо вмовляли скористатися послугами банку, але одне «незручне» питання — і менеджер раптом перетворюється на розлючене хамло. «Ну що неясно, програма так вимагає…»

Fly, you fools!

[1]: https://play.google.com/store/apps/details?id=ua.privatbank.cb
[2]: https://www.google.com/maps/timeline
