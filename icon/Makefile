SIZES = 16 32 36 48 57 60 72 76 96 114 120 144 152 180 192 194 256 384 512
ICONS = $(patsubst %,%.png,$(SIZES))

all: $(ICONS) 180w.png

%.png: icon.svg
	rsvg-convert $< -w $* -h $* -o $@
	optipng $@
	advpng -z4 $@

%w.png: %.png
	convert $< -background white -alpha remove -alpha off $@
