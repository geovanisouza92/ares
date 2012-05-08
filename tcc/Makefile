#! /bin/sh

all: bb tex bibtex tex tex view

bb:
	@ ebb ./figuras/*.*

tex:
	@ pdflatex -interaction=nonstopmode tcc

bibtex:
	@ bibtex tcc

view:
	@ evince tcc.pdf

clear:
	@ rm -f *.aux *.toc *.log *.bbl *.blg *.out *.pdf figuras/*.bb
