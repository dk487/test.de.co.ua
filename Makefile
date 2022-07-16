ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

-include .env

JEKYLL ?= jekyll
HTMLPROOFER ?= htmlproofer

# To run dockerized version of build tools, '.env' file should be like:
#
# JEKYLL = docker run --rm -v $(ROOT):/srv/jekyll jekyll/jekyll jekyll
# HTMLPROOFER = docker run --rm -v $(ROOT):/src klakegg/html-proofer

ASSETS := favicon.ico apple-touch-icon.png opengraph.png

all: build test

build: $(ASSETS)
	$(JEKYLL) build

favicon.ico: _icon/16-pixart.png _icon/32-pixart.png
	convert _icon/16-pixart.png tmp_favicon16.gif
	convert _icon/32-pixart.png tmp_favicon32.gif
	convert tmp_favicon16.gif tmp_favicon32.gif $@
	rm tmp_favicon16.gif tmp_favicon32.gif

apple-touch-icon.png: favicon.svg
	rsvg-convert $< -w 180 -h 180 | convert - -background white -alpha remove -alpha off $@
	optipng $@
	advpng -z4 $@

%.png: %.svg
	rsvg-convert $< -o $@
	optipng $@
	advpng -z4 $@

up:
	$(JEKYLL) build --drafts --watch

test:
	$(HTMLPROOFER) ./_site \
		--disable-external \
		--internal-domains https://test.de.co.ua \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names

test-full:
	$(HTMLPROOFER) ./_site \
		--internal-domains https://test.de.co.ua \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names \
		--enforce_https \
		--only-4xx

#		--report-invalid-tags \
#		--report-missing-doctype \
#		--report-eof-tags \
#		--report-mismatched-tags \
#		--check-sri \

slug ?= new-post
SLUG ?= $(slug)
POSTDATE = $(shell date "+%F %X %:z")
FILEDATE = $(shell date "+%Y/%F")
post:
	echo "---\ntitle: $(SLUG)\ndate: $(POSTDATE)\n---\n\n..." > _posts/$(FILEDATE)-$(SLUG).md

draft:
	echo "---\ntitle: $(SLUG)\nplaceholder: here\n---\n\n..." > _drafts/$(SLUG).md

draft ?= $(shell find _drafts -type f | head -n 1)
DRAFT ?= $(draft)
DSLUG = $(patsubst _drafts/%.md,%,$(DRAFT))
pub:
	[ -f $(DRAFT) ]
	mv $(DRAFT) _posts/$(FILEDATE)-$(DSLUG).md
	sed -i "s/^placeholder: here/date: $(POSTDATE)/" _posts/$(FILEDATE)-$(DSLUG).md

geany:
	git st --porcelain | egrep '(_posts|_drafts)' | cut -c 4- | xargs -L1 geany

.PHONY: all build up test post draft pub geany
