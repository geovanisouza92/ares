
CLEAN= \
  ../docs/grammar.* \
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

tcc: docs bb tex index bibtex
	@ $(MAKE) tex
	@ $(MAKE) tex
	@ $(MAKE) tex

clean:
	@ clear
	@ rm -rf bin/$(BINARY) $(MODULES) $(CLEAN)

docs: clean
	@ echo "Gerando documentação"
	@ # Resumir saída do parser
	@ echo '<?xml version="1.0"?><bison-xml-report version="2.5" bug-report="bug-bison@gnu.org" url="http://www.gnu.org/software/bison/"><filename>Ares</filename><grammar>' >> ../docs/grammar.xml
	@ echo "sed -n '`grep -n '<rules>' ../src/parser.xml | grep -o '[0-9]*'`,`grep -n '</rules>' ../src/parser.xml | grep -o '[0-9]*'` p' ../src/parser.xml >> ../docs/grammar.xml" | bash
	@ echo '</grammar></bison-xml-report>' >> ../docs/grammar.xml
	@ # Converter saída resumida em texto
	@ xsltproc ../docs/xslt/xml2xhtml.xsl ../docs/grammar.xml > ../docs/grammar.html
	@ xsltproc ../docs/xslt/xml2text.xsl ../docs/grammar.xml > ../docs/grammar.bnf
	@ # Gerar relatório do parser em tex
	@ echo "\\\\apendice\\\\chapter{Gram\\\\'atica BNF da linguagem de programa\\\\ca o do prot\\\\'otipo}\\\\begin{espacosimples}\\\\begin{scriptsize}\\\\begin{lstlisting}" >> grammar.tex
	@ cat ../docs/grammar.bnf | sed "s/\\$$/\\\$$/" >> grammar.tex
	@ echo "\\\\end{lstlisting}\\\\end{scriptsize}\\\\end{espacosimples}" >> grammar.tex

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