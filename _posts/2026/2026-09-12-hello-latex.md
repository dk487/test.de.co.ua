---
title: Привіт, LaTeX!
date: 2026-09-12 09:33:53 +03:00
---

Ох, куди ж я лізу… Мені забракне мізків, сил та часу. Але все ж.

```make
# make another.pdf
# DOC=another make
DOC ?= main

all: $(DOC).pdf

.SECONDEXPANSION:
%.pdf: %.tex $$(wildcard %_*.tex) $$(wildcard %.bib)
	latexmk -xelatex -interaction=nonstopmode $<

clean: purge
	-rm -fv -- $(DOC).pdf

purge:
	-rm -fv -- $(wildcard *.aux *.bbl *.bcf *.blg *.log \
	*.run.xml *.toc *.fls *.fdb_latexmk *.xdv *-SAVE-ERROR)

# xdg-mime query default application/pdf
# xdg-mime default qpdfview.desktop 'application/pdf'
open: all
	open $(DOC).pdf

.PHONY: all clean purge open
```
