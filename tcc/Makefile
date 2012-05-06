#! /bin/sh

all: bb tex bibtex tex tex view

bb:
	@ ebb figuras/*.*

tex:
	@ pdflatex -iteration=nonstopmode tcc

bibtex:
	@ bibtex tcc

view:
	@ evince tcc.pdf

clear:
	@ rm *.aux *.toc *.log *.bbl *.blg *.out *.pdf
	@ rm figuras/*.bb
