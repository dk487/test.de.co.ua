---
title: Kyiv not Kiev
title_lang: en
date: 2022-08-23 02:55:04 +03:00
---

Зазвичай у каталогу `/etc` я роблю репозитарій Git. Зручно після `apt upgrade` дивитися, що змінилося.

Дивіться, що змінилося у Debian Sid останнім часом!

```diff
root@carmilhan:/etc# git diff timezone
diff --git a/timezone b/timezone
index 123c955..6fa621a 100644
--- a/timezone
+++ b/timezone
@@ -1 +1 @@
-Europe/Kiev
+Europe/Kyiv
```
