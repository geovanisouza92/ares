
LEVEL=..

CLEAN= \
  tcc.pdf \
  grammar.tex \
  figuras/*.bb \
  *.aux \
  *.log \
  *.lof \
  *.lol \
  *.out \
  *.sig* \
  *.sym* \
  *.toc \
  *.bbl \
  *.blg \
  *.ilg \
  *.results

clean-local::
	@ rm -rf $(CLEAN)

tcc.pdf: grammar.tex bb tex index bibtex
	@ $(MAKE) tex
	@ $(MAKE) tex
	@ $(MAKE) tex

grammar.tex:
	cd $(LEVEL)/docs && $(MAKE) docs

bb:
	@ ebb figuras/*.*

tex:
	@ pdflatex tcc.tex

index: sigla

sigla:
	@ makeindex -s tabela-simbolos.ist -o tcc.sigla tcc.siglax

bibtex:
	@ bibtex tcc

include $(LEVEL)/Makefile.common
