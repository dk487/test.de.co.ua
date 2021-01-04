all: build test

build:
	jekyll build

test:
	htmlproofer ./_site

post:
	echo "---\ntitle: XXX\ndate: `date "+%F %X %z"`\n---\n\n..." \
		> _posts/`date +%F`-new-post.md

.PHONY: all build test post
