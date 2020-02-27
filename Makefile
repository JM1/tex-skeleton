# Copyright (c) 2019-2020 Jakob Meng, <jakobmeng@web.de>
# vim:set syntax=make:
# kate: syntax Makefile; tab-indents on; replace-tabs off;

ifeq ($(wildcard .git),)
    $(error YOU HAVE TO USE GIT TO DOWNLOAD THIS REPOSITORY. ABORTING.)
endif

TEX=master
OUT=out

.DEFAULT_GOAL := all

.PHONY: all clean submodulesclean submodulesupdate distclean

$(OUT):
	@mkdir -p $(OUT)

$(OUT)/$(TEX).pdf: $(TEX).tex $(wildcard fgmt_*.tex rsrc_* language-*.dict) $(OUT)
	@if git submodule status | egrep -q '^[-]|^[+]' ; then   \
		git submodule update --quiet --init --recursive; \
	fi
	pdflatex -halt-on-error -shell-escape -draft-mode -output-directory $(OUT) $<
	biber --output-directory $(OUT) $(TEX)
	pdflatex -halt-on-error -shell-escape -draft-mode -output-directory $(OUT) $<
	pdflatex -halt-on-error -shell-escape             -output-directory $(OUT) $<

$(TEX).pdf: $(OUT)/$(TEX).pdf
	@cp -f $< $@

all: $(TEX).pdf

clean:
	@rm -rf "$(OUT)"

submodulesclean:
	@git submodule foreach --quiet --recursive git clean -ff -x -d
	@git submodule update --quiet --init --recursive --force || true
	@git submodule sync --recursive
	@git submodule update --init --recursive --force

submodulesupdate:
	@git submodule update --quiet --init --recursive || true
	@git submodule sync --recursive
	@git submodule update --init --recursive

distclean:
	@git submodule deinit -f .
	@git clean -ff -x -d
