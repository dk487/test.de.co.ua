ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

-include .env

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

dev:
	$(JEKYLL) build --drafts --watch

test:
	$(HTMLPROOFER) ./_site \
		--assume-extension \
		--http-status-ignore "0,400" \
		--check-html \
		--check-opengraph \
		--check-sri \
		--enforce_https \
		--url-swap "https\:\/\/test\.de\.co\.ua:"

slug ?= new-post
SLUG ?= $(slug)
post:
	echo "---\ntitle: $(SLUG)\ndate: `date "+%F %X %:z"`\n---\n\n..." > _posts/`date +%Y/%F`-$(SLUG).md

.PHONY: geany
geany:
	git st --porcelain | grep _posts | cut -c 4- | xargs -L1 geany

.PHONY: all build test post
