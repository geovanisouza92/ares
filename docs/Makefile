
LEVEL=..

all-local:: docs

clean-local::
	@ rm -rf grammar.html grammar.xml parser.output parser.xml grammar.bnf

parser.xml:
	cd $(LEVEL)/lib/ares && $(MAKE) parser.cpp

docs: parser.xml
	@ echo "Gerando documentação"
	@ echo '<?xml version="1.0"?><bison-xml-report version="2.5" bug-report="bug-bison@gnu.org" url="http://www.gnu.org/software/bison/"><filename>Ares</filename><grammar>' > grammar.xml
	@ echo "sed -n '`grep -n '<rules>' parser.xml | grep -o '[0-9]*'`,`grep -n '</rules>' parser.xml | grep -o '[0-9]*'` p' parser.xml >> grammar.xml" | bash
	@ echo '</grammar></bison-xml-report>' >> grammar.xml
	@ xsltproc xslt/xml2xhtml.xsl grammar.xml > grammar.html
	@ xsltproc xslt/xml2text.xsl grammar.xml > grammar.bnf
	@ echo "\\\\apendice\\\\chapter{Gram\\\\'atica BNF da linguagem de programa\\\\ca o do prot\\\\'otipo}\\\\begin{espacosimples}\\\\begin{scriptsize}\\\\begin{lstlisting}" > $(LEVEL)/tcc/grammar.tex
	@ cat grammar.bnf | sed "s/\\$$/\\\$$/" >> $(LEVEL)/tcc/grammar.tex
	@ echo "\\\\end{lstlisting}\\\\end{scriptsize}\\\\end{espacosimples}" >> $(LEVEL)/tcc/grammar.tex

include $(LEVEL)/Makefile.common
