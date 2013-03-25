
LEVEL=..

CLEAN= \
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
  *.results \
  tcc.pdf \
  proposta-pesquisa.pdf \
  proposta/*.aux \
  er.pdf \
  er/*.aux

clean-local::
	@ rm -rRf $(CLEAN)

all-local:: pp er tcc

#########################################

pp: common-bb
	@ pdflatex proposta-pesquisa.tex
	@ bibtex proposta-pesquisa
	@ pdflatex proposta-pesquisa.tex
	@ pdflatex proposta-pesquisa.tex	@ echo foo
	@ pdflatex proposta-pesquisa.tex

#########################################

er: common-bb
	@ pdflatex er.tex
	@ makeindex -s tabela-simbolos.ist -o er.sigla er.siglax
	@ bibtex er
	@ pdflatex er.tex
	@ pdflatex er.tex
	@ pdflatex er.tex

#########################################

tcc: common-bb
	cd $(LEVEL)/docs && $(MAKE) docs
	@ pdflatex tcc.tex
	@ makeindex -s tabela-simbolos.ist -o tcc.sigla tcc.siglax
	@ bibtex tcc
	@ pdflatex tcc.tex
	@ pdflatex tcc.tex
	@ pdflatex tcc.tex

#########################################

common-bb:
	@ ebb figuras/*.png
	@ ebb figuras/*.jpg

include $(LEVEL)/Makefile.common
