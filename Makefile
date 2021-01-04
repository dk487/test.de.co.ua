all: build test

build:
	jekyll build

test:
	htmlproofer ./_site \
		--assume-extension \
		--url-ignore "/twitter.com/,/kastaneda.kiev.ua/" \
		--check-html \
		--check-opengraph \
		--check-sri \
		--enforce_https

post:
	echo "---\ntitle: XXX\ndate: `date "+%F %X %z"`\n---\n\n..." \
		> _posts/`date +%F`-new-post.md

.PHONY: all build test post
