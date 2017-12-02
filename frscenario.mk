PRINT=$(BASENAME).pdf
WEB=$(BASENAME).html $(BASENAME).css

define TEST_SEQUENCE=
perl -ne 'BEGIN{$$skip=1;$$found=0;} $$skip=0 if(m/begin\s*{document}/); if(!$$skip && m/$(1)/){print;$$found=1;} END{exit $$found}' $(2)
endef

define TEST_TEX=
echo \
&& echo " * Guillemets ouvrants suivis d'une espace insécable (utiliser «~ pour passer outre) :" \
&& $(call TEST_SEQUENCE,«\xC2\xA0,$(1)) \
&& echo " * Guillemets fermants précédés d'une espace insécable (utiliser ~» pour passer outre) :" \
&& $(call TEST_SEQUENCE,\xC2\xA0»,$(1))
endef

print: $(PRINT)

web: $(WEB)

%.pdf: %.tex
	@$(call TEST_TEX,$<)
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
