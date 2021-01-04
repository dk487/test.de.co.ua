ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

ifeq ($(APP_ENV), test)
  JEKYLL := docker run --rm -v $(ROOT):/srv/jekyll jekyll/jekyll jekyll
  HTMLPROOFER := docker run --rm -v $(ROOT)_site:/_site 18fgsa/html-proofer
else
  JEKYLL := jekyll
  HTMLPROOFER := htmlproofer
endif

all: build test

build:
	$(JEKYLL) build

test:
	$(HTMLPROOFER) ./_site \
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
