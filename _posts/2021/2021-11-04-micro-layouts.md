---
title: Micro-layouts
title_lang: en
date: 2021-11-04 03:04:55 +02:00
mtime: 2021-12-11 17:54:04 +02:00
---

Знайшов невелику, але дуже чудову [статтю про <span lang="en">layout</span> компонентів][1]. Дуже надихає.

Особливо сподо́балося ось це:

```css
h1 {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  gap: 1em;
}
h1::before,
h1::after {
  content: "";
  border-top: 0.1em double black;
  align-self: center;
}
```

[1]: https://web.dev/learn/design/micro-layouts/
