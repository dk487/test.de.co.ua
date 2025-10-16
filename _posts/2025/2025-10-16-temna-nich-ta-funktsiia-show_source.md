---
title: Темна ніч та функція show_source()
date: 2025-10-16 00:48:26 +00:00
---

Швидкий брудний пост. Я під час розробки на PHP іноді користуюсь [`show_source()`][1]. Ну, знаєте, буває треба показати код і при цьому _хоч якось_ підсвітити синтаксис, не встановлюючи тонну зовнішніх залежностей.

Так, це анахронізм часів PHP4. І так, за замовчанням кольори там розраховані на світле тло. Якщо у вас сайт з темним фоном, то можна [поміняти кольори][2] на щось відповідне, але це все трошки бісить.

А що як у нас сучасна адаптивна кольорова схема?

```html
<meta name="color-scheme" content="light dark">
``` 

Тоді у нас взагалі не може бути фіксованих кольорів, бо має одночасно існувати і варіант для темної схеми, і варіант для світлої.

Спробував через [змінні CSS][3]. Погнали.

Пишемо в `php.ini` щось таке:

```ini
highlight.default = "var(--php-default)"
highlight.html = "var(--php-html)"
highlight.keyword = "var(--php-keyword)"
highlight.string = "var(--php-string)"
highlight.comment = "var(--php-comment)"
```

Або, якщо змінювати `php.ini` незручно, робимо це в runtime в PHP:

```php
foreach (['default', 'html', 'keyword', 'string', 'comment'] as $key) {
    ini_set('highlight.' . $key, 'var(--php-' . $key . ')');
}
```

І тепер нам треба приблизно отакий CSS:

```css
:root {
  --php-comment: #f800;
  --php-default: #00b;
  --php-html: #000;
  --php-keyword: #070;
  --php-string: #d00;
}

@media (prefers-color-scheme: dark) { 
  :root {
    --php-comment: #860;
    --php-default: #66f;
    --php-html: #ccc;
    --php-keyword: #0f3;
    --php-string: #fc0;
  }
}
```

Всьо, пофарбували, порядок :)

[1]: https://www.php.net/manual/uk/function.show-source.php
[2]: https://www.php.net/manual/uk/misc.configuration.php#ini.syntax-highlighting
[3]: https://developer.mozilla.org/en-US/docs/Web/CSS/var
