PRINT=$(BASENAME).pdf $(BASENAME).cover.pdf
DRAFT=$(BASENAME).draft.pdf
EBOOK=$(BASENAME).epub
PRINTIMAGEDIR=pictures
EBOOKIMAGEDIR=images
PNGS=$(wildcard *.png)
JPGS=$(wildcard *.jpg)
PRINTIMAGES=$(addprefix $(PRINTIMAGEDIR)/, $(PNGS)) $(addprefix $(PRINTIMAGEDIR)/,  $(JPGS))
EBOOKIMAGES=$(addprefix $(EBOOKIMAGEDIR)/, $(PNGS)) $(addprefix $(EBOOKIMAGEDIR)/,  $(JPGS))

all: draft print ebook

draft: $(DRAFT)

print: $(PRINT)

ebook: $(EBOOK)

$(PRINTIMAGEDIR)/%.png: %.png
	mkdir -p $(PRINTIMAGEDIR)
	echo '(convert-print "$<" "$@" "png") (gimp-quit 0)' | cat $(LATEXFILES)/gimpFunctions.scm - | gimp -i -b -

$(PRINTIMAGEDIR)/%.jpg: %.jpg
	mkdir -p $(PRINTIMAGEDIR)
	echo '(convert-print "$<" "$@" "jpg") (gimp-quit 0)' | cat $(LATEXFILES)/gimpFunctions.scm - | gimp -i -b -

$(EBOOKIMAGEDIR)/%.png: %.png
	mkdir -p $(EBOOKIMAGEDIR)
	echo '(convert-ebook "$<" "$@" "png") (gimp-quit 0)' | cat $(LATEXFILES)/gimpFunctions.scm - | gimp -i -b -

$(EBOOKIMAGEDIR)/%.jpg: %.jpg
	mkdir -p $(EBOOKIMAGEDIR)
	echo '(convert-ebook "$<" "$@" "jpg") (gimp-quit 0)' | cat $(LATEXFILES)/gimpFunctions.scm - | gimp -i -b -

%.draft.pdf: %.tex
	TEXINPUTS=".:$(LATEXFILES):" latexmk -pdf -jobname=$(basename $@) -pdflatex="pdflatex -jobname=$(basename $@) '\\newcommand\\ModeBrouillon{1} \\input{%S}'" $<
	latexmk -jobname=$(basename $@) -c

%.pdf %.data: %.tex $(PRINTIMAGES)
	TEXINPUTS=".:$(LATEXFILES):" latexmk -pdf -pdflatex=pdflatex $<
	latexmk -c

%.cover.pdf: %.sla %.data
	scribus -g -ns $< -py $(LATEXFILES)/createCover.py $@ $*.data

%.cover.ppm: %.cover.pdf
	pdftoppm -singlefile -r $(COVERRES) $< >$@

%.cover.png: %.cover.ppm
	echo '(extract-cover "$<" "$@" $(COVERRES) $(COVERCUT)) (gimp-quit 0)' | cat $(LATEXFILES)/gimpFunctions.scm - | gimp -i -b -

%.html %.css %.opf: %.tex
	TEXINPUTS=".:$(LATEXFILES):" mk4ht htlatex $< "xhtml,fn-in,charset=utf-8" " -cunihtf -utf8"
	rm -f $*.4ct $*.4tc $*.aux $*.dvi $*.idv $*.lg $*.log $*.tmp $*.xref
ifdef FONT_SERIF
	perl -i -pe 's/font-family:\s*serif;/font-family: $(FONT_SERIF);/g' $*.css
endif
ifdef FONT_CURSIVE
	perl -i -pe 's/font-family:\s*cursive;/font-family: $(FONT_CURSIVE);/g' $*.css
endif

%.epub: %.html %.css %.opf %.cover.png $(EBOOKIMAGES)
	ebook-convert $< $@ --embed-all-fonts --subset-embedded-fonts --cover $*.cover.png --from-opf $*.opf

clean:
	rm -f *~
	rm -f *.data *.html *.css *.opf
	rm -rf $(PRINTIMAGEDIR) $(EBOOKIMAGEDIR)

mrproper: clean
	rm -f $(DRAFT) $(PRINT) $(EBOOK)

.SUFFIXES:

.PHONY : all draft print ebook clean mrproper
