
LEVEL=..

CLEAN= \
  tcc.pdf \
  proposta.pdf \
  proposta2.pdf \
  grammar.tex \
  figuras/*.bb \
  *.aux \
  proposta/*.aux \
  *.log \
  proposta/*.log \
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

tcc.pdf: grammar.tex bb tcctex index bibtex
	@ $(MAKE) tcctex
	@ $(MAKE) tcctex
	@ $(MAKE) tcctex

proposta.pdf: bb propotex bibtexpropo
	@ $(MAKE) propotex
	@ $(MAKE) propotex
	@ $(MAKE) propotex
	# @ $(MAKE) bibtexpropo

proposta2.pdf: bb propo2tex bibtexpropo2
	@ $(MAKE) propo2tex
	@ $(MAKE) propo2tex
	@ $(MAKE) propo2tex
	# @ $(MAKE) bibtexpropo2

grammar.tex:
	cd $(LEVEL)/docs && $(MAKE) docs

bb:
	@ ebb figuras/*.*

tcctex:
	@ pdflatex tcc.tex

propotex:
	@ pdflatex proposta.tex

propo2tex:
	@ pdflatex proposta2.tex

index: sigla

sigla:
	@ makeindex -s tabela-simbolos.ist -o tcc.sigla tcc.siglax

bibtex:
	@ bibtex tcc

bibtexpropo:
	@ bibtex proposta

bibtexpropo2:
	@ bibtex proposta2

include $(LEVEL)/Makefile.common
