PRINT=$(BASENAME).pdf
WEB=$(BASENAME).html $(BASENAME).css

print: $(PRINT)

web: $(WEB)

%.pdf: %.tex
	TEXINPUTS=".:$(LATEXFILES):" latexmk -pdf -pdflatex=pdflatex $<
	latexmk -c

%.html %.css: %.tex
	TEXINPUTS=".:$(LATEXFILES):" mk4ht htlatex $< "xhtml,fn-in,charset=utf-8" " -cunihtf -utf8"
	rm -f $*.4ct $*.4tc $*.aux $*.dvi $*.idv $*.lg $*.log $*.tmp $*.xref

clean:
	rm -f $(BASENAME)~

mrproper: clean
	rm -f $(PRINT) $(WEB)

.SUFFIXES:

.PHONY : print web clean mrproper
