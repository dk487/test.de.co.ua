---
title: Автоматизація часу публакації
date: 2023-04-14 21:31:10 +03:00
---

Так, спробую один фокус…

Наче працює: `make time` оновлює поле date у front matter для нових постів.
А ну, спробую. 

```
make time && git add -A && git ci -m "New post: date/time automation"
```