---
title: New Makefile target
date: 2020-08-16 18:39:33 +03:00
---

Мені постійно чогось такого не вистачало. Зробив `make post` і пишу у ньому.

```Makefile
post:
	echo "---\ntitle: XXX\ndate: `date "+%F %X %z"`\n---\n\n..." \
		> _posts/`date +%F`-new-post.md
```
