---
title: Hello Atom, my old friend
date: 2020-08-14 18:08:00 +03:00
---

Встановив собі Atom 1.50, підключив свої старі конфіги. Наче все працює.

Але… Якось все дивно.

Тут, щоб прибрати бічну панель, треба тиснути `Ctrl-\`, а в VSCode — `Ctrl-B`.
Atom має multi-cursor по Ctrl-клік, а VSCode потребує «перемикання в режим multi-cursor».
Наче Atom все ж зручніше, але я не певен.

Upd.: запустив і те, і інше. Гмм.

Upd.#2: спробую скласти мій _персональний хіт-парад_ у табличку.

+------------------+---------------------+------------+------+
| Feature          | Atom                | VSCode     | Wins |
+------------------+---------------------+------------+------+
| Markdown style   | No bold/italic      | Nice look  | Code |
| MD preview       | `Ctrl-Stift-M`      | Button     | Code |
| Projects/folders | «Add folder to…»    | Workspace? | Atom |
| Git commit       | Bottom right icon   | Left bar   | Code |
+------------------+---------------------+------------+------+

### Markdown style

Коли я редагую Markdown, я хочу бачити **bold** та _italic_ безпосередньо. Не обов'язково через font-weight та font-style, це може бути колір / фон / font-decoration. Курва, я хочу бачити заголовки та посилання!

Схоже, що Atom з пакетом `language-markdown` ніяк не підсвічує стилі. А ось у VSCode все добре з цим.


### Markdown preview

Ну, це дрібниці.


### Projects/folders

Є чітке відчуття, що у Atom'і ліва панель — це мої проекти (каталогі) і нічого більше. Легко відкрити, легко закрити, нічого зайвого.

VSCode напхав туди все. І головне ­— там відбувається git add / git commit.


### Git commit

Визнаю. VSCode зручніше. Натиснув «плюсики» на потрібних файлах, написав commit message, `Ctrl-Enter`.