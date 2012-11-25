
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
  proposta/*.aux

clean-local::
	@ rm -rRf $(CLEAN)

all-local:: tcc proposta-pesquisa

tcc:
	@ $(MAKE) grammar-tex
	@ $(MAKE) bb
	@ $(MAKE) tcc-tex
	@ $(MAKE) index
	@ $(MAKE) bibtex-tcc
	@ $(MAKE) tcc-tex
	@ $(MAKE) tcc-tex
	@ $(MAKE) tcc-tex

proposta-pesquisa:
	@ $(MAKE) bb
	@ $(MAKE) proposta-pesquisa-tex
	@ $(MAKE) bibtex-proposta-pesquisa
	@ $(MAKE) proposta-pesquisa-tex
	@ $(MAKE) proposta-pesquisa-tex
	@ $(MAKE) proposta-pesquisa-tex

grammar-tex:
	cd $(LEVEL)/docs && $(MAKE) docs

bb:
	@ ebb figuras/*.png
	@ ebb figuras/*.jpg

tcc-tex:
	@ pdflatex tcc.tex

proposta-pesquisa-tex:
	@ pdflatex proposta-pesquisa.tex

index: sigla

sigla: tcc-tex
	@ makeindex -s tabela-simbolos.ist -o tcc.sigla tcc.siglax

bibtex-tcc: tcc-tex
	@ bibtex tcc

bibtex-proposta-pesquisa: proposta-pesquisa-tex
	@ bibtex proposta-pesquisa

include $(LEVEL)/Makefile.common
