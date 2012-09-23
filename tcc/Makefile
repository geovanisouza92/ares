
LEVEL=..

CLEAN= \
  tcc.pdf \
  proposta.pdf \
  grammar.tex \
  figuras/*.bb \
  *.aux \
  proposta/*.aux \
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

proposta.pdf: bb propotex bibtexpropo
	@ $(MAKE) propotex
	@ $(MAKE) propotex
	@ $(MAKE) propotex

grammar.tex:
	cd $(LEVEL)/docs && $(MAKE) docs

bb:
	@ ebb figuras/*.*

tex:
	@ pdflatex tcc.tex

propotex:
	@ pdflatex proposta.tex

index: sigla

sigla:
	@ makeindex -s tabela-simbolos.ist -o tcc.sigla tcc.siglax

bibtex:
	@ bibtex tcc

bibtexpropo:
	@ bibtex proposta

include $(LEVEL)/Makefile.common
