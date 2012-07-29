
LEVEL=..

CLEAN= \
  figuras/*.bb \
  tcc.pdf \
  grammar.tex \
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

all-local:: tcc

clean-local::
	@ rm -rf $(CLEAN)

tcc: bb tex index bibtex
	@ $(MAKE) tex
	@ $(MAKE) tex
	@ $(MAKE) tex

bb:
	@ echo "Gerando arquivos de imagens"
	@ ebb figuras/*.*

tex:
	@ echo "Gerando tcc"
	@ pdflatex tcc.tex

index: sigla

sigla:
	@ echo "Gerando índice de siglas"
	@ makeindex -s tabela-simbolos.ist -o tcc.sigla tcc.siglax

bibtex:
	@ echo "Gerando referências bibliográficas"
	@ bibtex tcc

include $(LEVEL)/Makefile.common
