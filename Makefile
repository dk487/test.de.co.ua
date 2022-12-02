# To install the build environment:
# apt install make jekyll imagemagick librsvg2-bin optipng advancecomp

ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

-include .env

JEKYLL ?= jekyll
HTMLPROOFER ?= htmlproofer

# To run dockerized version of build tools, '.env' file should be like:
#
# JEKYLL = docker run --rm -v $(ROOT):/srv/jekyll jekyll/jekyll jekyll
# HTMLPROOFER = docker run --rm -v $(ROOT):/src klakegg/html-proofer

DOMAIN := test.de.co.ua
ASSETS := favicon.ico apple-touch-icon.png opengraph.png
TEXTFILES := '.*\.\(html\|css\|js\|txt\|xml\|ico\)$$'

all: build test-local

favicon.ico: _icon/16-pixart.png _icon/32-pixart.png
	convert _icon/16-pixart.png tmp_favicon16.gif
	convert _icon/32-pixart.png tmp_favicon32.gif
	convert tmp_favicon16.gif tmp_favicon32.gif $@
	rm tmp_favicon16.gif tmp_favicon32.gif

slug ?= new-post
SLUG ?= $(slug)
POSTDATE = $(shell date "+%F %X %:z")
FILEDATE = $(shell date "+%Y/%F")
post:
	echo "---\ntitle: $(SLUG)\ndate: $(POSTDATE)\n---\n\n..." > _posts/$(FILEDATE)-$(SLUG).md

draft:
	echo "---\ntitle: $(SLUG)\nplaceholder: here\n---\n\n..." > _drafts/$(SLUG).md

draft ?= $(shell find _drafts -type f | grep -v .gitkeep | head -n 1)
DRAFT ?= $(draft)
DSLUG = $(patsubst _drafts/%.md,%,$(DRAFT))
pub:
	[ -f $(DRAFT) ]
	mv $(DRAFT) _posts/$(FILEDATE)-$(DSLUG).md
	sed -i "s/^placeholder: here/date: $(POSTDATE)/" _posts/$(FILEDATE)-$(DSLUG).md

geany:
	git st --porcelain | egrep '(_posts|_drafts)' | cut -c 4- | xargs -L1 geany

apple-touch-icon.png: favicon.svg
	rsvg-convert $< -w 180 -h 180 | convert - -background white -alpha remove -alpha off $@
	optipng $@
	advpng -z4 $@

%.png: %.svg
	rsvg-convert $< -o $@
	optipng $@
	advpng -z4 $@

build: $(ASSETS)
	$(JEKYLL) build

up: $(ASSETS)
	$(JEKYLL) build --drafts --watch

test: test-local

test-local: build
	$(HTMLPROOFER) ./_site \
		--disable-external \
		--internal-domains https://$(DOMAIN) \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names \
		--report-missing-doctype \
		--report-invalid-tags \
		--report-eof-tags \
		--report-mismatched-tags \
		--check-sri \
		--enforce_https \
		--url-ignore "/http\:\/\/.*\.(onion|localhost)/"

test-external: build
	$(HTMLPROOFER) ./_site \
		--internal-domains https://$(DOMAIN) \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names \
		--report-missing-doctype \
		--report-invalid-tags \
		--report-eof-tags \
		--report-mismatched-tags \
		--check-sri \
		--enforce_https \
		--url-ignore "/http\:\/\/.*\.(onion|localhost)/" \
		--only-4xx

clean:
	rm -fv $(ASSETS)
	rm -frv _site/
	rm -fv $(DOMAIN).tar.gz

compress:
	find _site -regex $(TEXTFILES) | xargs zopfli --i20
	find _site -regex $(TEXTFILES) | xargs brotli -fZ

package: build compress $(DOMAIN).tar.gz

$(DOMAIN).tar.gz:
	tar zcf $@ -C _site/ .

.PHONY: all post draft pub geany build up test test-local test-external clean compress package $(DOMAIN).tar.gz
