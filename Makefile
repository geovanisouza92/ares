##===- projects/sample/Makefile ----------------------------*- Makefile -*-===##
#
# This is a sample Makefile for a project that uses LLVM.
#
##===----------------------------------------------------------------------===##

#
# Indicates our relative path to the top of the project's root directory.
#
LEVEL = .
DIRS = lib tools
EXTRA_DIST = include

#
# Include the Master Makefile that knows how to build all.
#
include $(LEVEL)/Makefile.common

# <<<<<<< Updated upstream
# YACC=bison
# LEX=flex
# CXX=clang++
# LD=llvm-ld

# ifeq ($(RELEASE),1)
# CXXFLAGS= \
#   -emit-llvm \
#   -Wall \
#   -c \
#   -fmessage-length=0 \
#   -Wno-unused-function \
#   -Wno-logical-op-parentheses \
#   -Wno-switch
# LDFLAGS= \
#   -v \
#   -native \
#   -lstdc++ \
#   -lboost_filesystem \
#   -lboost_program_options \
#   -lboost_system \
#   -L/usr/lib/gcc/i686-linux-gnu/4.6/ \
#   -L/home/geovani/dev/boost_1_48_0/bin.v2/libs/program_options/build/gcc-4.6.1/release/link-static/threading-multi \
#   -L/home/geovani/dev/boost_1_48_0/bin.v2/libs/system/build/gcc-4.6.1/release/link-static/threading-multi \
#   -L/home/geovani/dev/boost_1_48_0/bin.v2/libs/filesystem/build/gcc-4.6.1/release/link-static/threading-multi
# LFLAGS=
# YFLAGS= \
#   -v \
#   -x \
#   --defines=src/parser.hpp
# else
# CXXFLAGS= `llvm-config --cxxflags` \
#   -emit-llvm \
#   -Wno-switch \
#   -DLANG_DEBUG
#   # -Wall \
#   # -c \
#   # -g3 \
#   # -fmessage-length=0 \
#   # -Wno-unused-function \
#   # -Wno-logical-op-parentheses \
#   # -Wno-switch-enum \
# LDFLAGS= `llvm-config --ldflags --libs engine` \
#   -native \
#   -lstdc++ \
#   -lboost_filesystem \
#   -lboost_program_options \
#   -lboost_system \
#   -L/usr/lib/gcc/i686-linux-gnu/4.6/ \
#   -L/home/geovani/dev/boost_1_48_0/bin.v2/libs/program_options/build/gcc-4.6.1/release/link-static/threading-multi \
#   -L/home/geovani/dev/boost_1_48_0/bin.v2/libs/system/build/gcc-4.6.1/release/link-static/threading-multi \
#   -L/home/geovani/dev/boost_1_48_0/bin.v2/libs/filesystem/build/gcc-4.6.1/release/link-static/threading-multi
#   # -L/usr/lib/i386-linux-gnu/ \
#   # -v \
# LFLAGS=--debug
# YFLAGS= \
#   -v \
#   -x \
#   --debug \
#   --defines=src/parser.hpp
# endif

# BINARY=arc
# MODULES= \
#   src/st.bc \
#   src/stoql.bc \
#   src/stmt.bc \
#   src/parser.bc \
#   src/scanner.bc \
#   src/driver.bc \
#   src/codegen.bc \
#   src/main.bc
# CLEAN= \
#   src/parser.cpp \
#   src/parser.hpp \
#   src/scanner.cpp \
#   src/*.out* \
#   src/*.hh \
#   *.results \
#   *.s \
#   src/*.bc \
#   bin/*.bc \
#   bin/arc* \
#   src/*.xml \
#   docs/grammar.*
# TEST_MODULES=`ls tests/*.ar`

# all: link
# 	@ echo "Concluído"

# src/parser.cpp:
# 	@ $(YACC) $(YFLAGS) -o $@ src/parser.yacc

# src/scanner.cpp:
# 	@ $(LEX) $(LFLAGS) -o$@ src/scanner.lex

# %.bc: %.cpp
# 	@ echo "Preparando dependência:" $@
# 	@ $(CXX) $(CXXFLAGS) -fcxx-exceptions -c -o $@ $< \

# link: $(MODULES)
# 	@ echo "Linkando compilador"
# 	@ $(LD) $(LDFLAGS) -o bin/$(BINARY) $(MODULES)

# test:
# 	@ if !([ -e bin/$(BINARY) ]); then make link; fi
# 	@ clear
# 	@ bin/$(BINARY) $(TEST_MODULES) 2> $@.results

# clean:
# 	@ clear
# 	@ rm -rf bin/$(BINARY) $(MODULES) $(CLEAN)
# 	@ cd tcc && $(MAKE) $@ && cd ..

# docs: src/parser.cpp
# 	@ echo "Gerando documentação"
# 	@ # Resumir saída do parser
# 	@ echo '<?xml version="1.0"?><bison-xml-report version="2.5" bug-report="bug-bison@gnu.org" url="http://www.gnu.org/software/bison/"><filename>Ares</filename><grammar>' >> docs/grammar.xml
# 	@ echo "sed -n '`grep -n '<rules>' src/parser.xml | grep -o '[0-9]*'`,`grep -n '</rules>' src/parser.xml | grep -o '[0-9]*'` p' src/parser.xml >> docs/grammar.xml" | bash
# 	@ echo '</grammar></bison-xml-report>' >> docs/grammar.xml
# 	@ # Converter saída resumida em texto
# 	@ xsltproc docs/xslt/xml2xhtml.xsl docs/grammar.xml > docs/grammar.html
# 	@ xsltproc docs/xslt/xml2text.xsl docs/grammar.xml > docs/grammar.bnf
# 	@ # Gerar relatório do parser em tex
# 	@ echo "\\\\apendice\\\\chapter{Gram\\\\'atica BNF da linguagem de programa\\\\ca o do prot\\\\'otipo}\\\\begin{espacosimples}\\\\begin{scriptsize}\\\\begin{lstlisting}" >> tcc/grammar.tex
# 	@ cat docs/grammar.bnf | sed "s/\\$$/\\\$$/" >> tcc/grammar.tex
# 	@ echo "\\\\end{lstlisting}\\\\end{scriptsize}\\\\end{espacosimples}" >> tcc/grammar.tex

# tcc: docs
# 	@ cd tcc && $(MAKE) $@ && cd ..
# =======
# >>>>>>> Stashed changes
