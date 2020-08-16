---
title: 2020 08 16 New Makefile Target
date: 2020-08-16 18:43:35.961000000 +03:00
---

Мені постійно чогось такого не вистачало. Зробив `make post` і пишу у ньому.

```Makefile
post:
	echo "---\ntitle: XXX\ndate: `date "+%F %X %z"`\n---\n\n..." \
		> _posts/`date +%F`-new-post.md
```
