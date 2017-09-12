PRINT=$(BASENAME).pdf $(BASENAME).cover.pdf
DRAFT=$(BASENAME).draft.pdf
EBOOK=$(BASENAME).epub

all: draft print ebook

draft: $(DRAFT)

print: $(PRINT)

ebook: $(EBOOK)

%.draft.pdf: %.tex
	TEXINPUTS=".:$(LATEXFILES):" latexmk -pdf -jobname=$(basename $@) -pdflatex="pdflatex -jobname=$(basename $@) '\\newcommand\\ModeBrouillon{1} \\input{%S}'" $<
	latexmk -jobname=$(basename $@) -c
	rm -f $(basename $@).som

%.pdf %.data: %.tex
	TEXINPUTS=".:$(LATEXFILES):" latexmk -pdf -pdflatex=pdflatex $<
	latexmk -c
	rm -f $(basename $@).som

%.cover.pdf: %.sla %.data
	scribus -g -ns $< -py $(LATEXFILES)/autoPDF.py $@ $*.sla $*.data

%.cover.ppm: %.cover.pdf
	pdftoppm -singlefile -r $(COVERRES) $< >$@

%.cover.png: %.cover.ppm
	echo '(extract-cover "$<" "$@" $(COVERRES) $(COVERCUT)) (gimp-quit 0)' | cat $(LATEXFILES)/extractCover.scm - | gimp -i -b -

%.html %.css %.opf: %.tex
	TEXINPUTS=".:$(LATEXFILES):" mk4ht htlatex $< "xhtml,fn-in,charset=utf-8" " -cunihtf -utf8"
	rm -f $*.4ct $*.4tc $*.aux $*.dvi $*.idv $*.lg $*.log $*.tmp $*.xref

%.epub: %.html %.css %.opf %.cover.png
	ebook-convert $< $@ --embed-all-fonts --cover $*.cover.png --from-opf $*.opf

clean:
	rm -f *~
	rm -f *.data *.html *.css *.opf

mrproper: clean
	rm -f $(DRAFT) $(PRINT) $(EBOOK)

.INTERMEDIATE : *.data *.html *.css *.opf

.PHONY : all draft print ebook clean mrproper
