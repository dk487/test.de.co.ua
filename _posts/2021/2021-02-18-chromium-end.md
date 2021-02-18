---
title: The end of Chromium
date: 2021-02-18 07:07:00 +02:00
---

Я багато років користувався Chrome та Chromium на всіх своїх ноутбуках та смартфонах. Причому на ноутбуках використовую виключно Chromium, а не Chrome. [Різницю між Chromium та Chrome][1] я знаю добре, і використання Chrome для мене є неприпустимим.

Багато років я користувався синхронізацією закладок, історії та налаштувань. Це було зручно і якось _нормально_, наче справді XXI століття настало.

Та, на жаль, Google вирішив вбити Chromium (або смертельно поранити, один хрін), [заборонивши для Chromium доступ до API синхронізації][2]:

> During a recent audit, we discovered that some third-party Chromium based browsers were able to integrate Google features, such as **Chrome sync** and Click to Call, that are only intended for Google’s use. This meant that a small fraction of users could sign into their Google Account and store their personal Chrome sync data, such as bookmarks, not just with Google Chrome, but also with some third-party Chromium based browsers. We are limiting access to our private Chrome APIs starting on **March 15, 2021**.

«Small fraction of users» — це, зокрема, я. Я не планую «вирішувати» цю проблему переходом на Chrome. Для мене є принципова різниця між F/OSS та всім іншим софтом. На моїх ноутбуках немає Chrome і, сподіваюся, ніколи не буде (окрім як десь у VM).

Все це значить, що мій мобільний Chrome з 15 березня лишиться сам, наодинці, без синхронізації, бо інших Chrome у мене немає. На моїх ноутах всі мої Chromium'и лишаться без синхронізації і починають жити окремо. Працювати вони якось будуть, _але смак вже не той_.

Це сумно. Та вихід є.

Деякий час тому я почав використовувати Firefox як основний браузер на смартфоні, відповідно і на ноутах/десктопах теж. Я досі дещо потерпаю від зміни звичок, але бачу, що в цілому все працює чудово, чітко і круто. Щиро раджу всім, хто користується Android, принаймні спробувати Firefox.

Є дуже важлива особливість мобільного Firefox: на відміну від мобільного Chrome, тут є можливість встановлювати додатки (add-ons), і першим ділом варто встановити блокувальник реклами (uBlock, Ghostery або що вам до вподоби). Насправді, саме нездатність блокувати рекламу у мобільному Chrome була причиною мого переходу на Firefox; ну а те, що у Google вирішили вимкнути синхронізацію — ну то просто так співпало.

Chromium, ти був зі мною багато років, спочивай з миром.

Cross-post: <https://kastaneda.kiev.ua/2021/02/18/chromium-end.html><br>
Cross-post: <https://kastaneda.dreamwidth.org/558067.html><br>
Cross-post: <https://netassist.social/posts/34>

[1]: https://kastaneda.livejournal.com/211533.html

[2]: https://blog.chromium.org/2021/01/limiting-private-api-availability-in.html
