build:
	jekyll build

post:
	echo "---\ntitle: XXX\ndate: `date "+%F %X %z"`\n---\n\n..." \
		> _posts/`date +%F`-new-post.md

.PHONY: build post
