SIZES = 16 32 36 48 57 60 72 76 96 114 120 144 152 180 180w 192 194 256 384 512
ICONS = $(patsubst %,%.png,$(SIZES))

all: $(ICONS)

%w.png: %.png
	convert $< -background white -alpha remove -alpha off $@
	optipng $@
	advpng -z4 $@

%.png: icon.svg
	rsvg-convert $< -w $* -h $* -o $@
	optipng $@
	advpng -z4 $@
