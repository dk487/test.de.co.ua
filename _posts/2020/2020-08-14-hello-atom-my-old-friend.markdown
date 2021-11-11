---
title: Hello Atom, my old friend
date: 2020-08-14 18:08:00 +03:00
---

Встановив собі Atom 1.50, підключив свої старі конфіги. Наче все працює.

Але… Якось все дивно.

Тут, щоб прибрати бічну панель, треба тиснути `Ctrl-\`, а в VSCode — `Ctrl-B`.
Atom має multi-cursor по Ctrl-клік, а VSCode потребує «перемикання в режим multi-cursor».
Наче Atom все ж зручніше, але я не певен.

-----

Upd.: запустив і те, і інше. Гмм.

-----

Upd.#2: спробую скласти мій _персональний хіт-парад_ у табличку.

<div lang="en" markdown="1">

 Feature          | Atom                | VSCode     | Wins
------------------|---------------------|------------|------
 Markdown style   | No bold/italic      | Nice look  | Code
 MD preview       | `Ctrl-Stift-M`      | Button     | Code
 Projects/folders | «Add folder to…»    | Workspace? | Atom
 Git commit       | Bottom right icon   | Left bar   | Code

</div>


### <span lang="en">Markdown style</span>

Коли я редагую Markdown, я хочу бачити **bold** та _italic_ безпосередньо. Не обов'язково через font-weight та font-style, це може бути колір / фон / font-decoration. Курва, я хочу бачити заголовки та посилання!

Схоже, що Atom з пакетом `language-markdown` ніяк не підсвічує стилі. А ось у VSCode все добре з цим.


### <span lang="en">Markdown preview</span>

Ну, це дрібниці.


### <span lang="en">Projects/folders</span>

Є чітке відчуття, що у Atom'і ліва панель — це мої проекти (каталогі) і нічого більше. Легко відкрити, легко закрити, нічого зайвого.

VSCode напхав туди все. І головне ­— там відбувається git add / git commit.


### <span lang="en">Git commit</span>

Визнаю. VSCode зручніше. Натиснув «плюсики» на потрібних файлах, написав commit message, `Ctrl-Enter`.

-----

Upd.#3: лошпєти!

<div lang="en" markdown="1">
> Writing login information to the keychain failed with error 'libsecret-1.so.0: Ð½Ðµ Ð²Ð´Ð°Ð»Ð¾ÑÑ Ð²ÑÐ´ÐºÑÐ¸ÑÐ¸ ÑÐ°Ð¹Ð» Ð¾Ð±âÑÐºÑÑÐ² ÑÐ¿ÑÐ»ÑÐ½Ð¾Ð³Ð¾ Ð²Ð¸ÐºÐ¾ÑÐ¸ÑÑÐ°Ð½Ð½Ñ: ÐÐµÐ¼Ð°Ñ ÑÐ°ÐºÐ¾Ð³Ð¾ ÑÐ°Ð¹Ð»Ð° Ð°Ð±Ð¾ ÐºÐ°ÑÐ°Ð»Ð¾Ð³Ñ'.
</div>

Microsoft і проблеми з кодуванням! Не можу повірити своїм очам. 2020 рік на дворі, навколо лишився лише єдиний стандарт Unicode в єдиному правильному кодуванні UTF-8, і лише ці клоуни примудряються щось поламати.

Навіть без перекодування видно, що йому треба якусь лібу. Ладно, поставив йому `libsecret-1-0`.

<div lang="en" markdown="1">
> Writing login information to the keychain failed with error 'The name org.freedesktop.secrets was not provided by any .service files'.
</div>

Йооообана. Ну що за хєрня. Поставив `gnome-keyring`.

<div lang="en" markdown="1">
> Error while starting Sync: No account available
</div>

Бачу, вони там канкрєтно лоханулися з цією фічею. Не дуже-то й треба було. Просто не робіть такого більше ніколи.
