##===- projects/sample/lib/sample/Makefile -----------------*- Makefile -*-===##

#
# Indicate where we are relative to the top of the source tree.
#
LEVEL=../..

#
# Give the name of a library.  This will build a dynamic version.
#
LIBRARYNAME = ares

LEX = flex
YACC = bison
LFLAGS = --debug
YFLAGS += -v -x --defines=$(LEVEL)/include/parser.h --debug

all-local:: parser.cpp scanner.cpp

clean-local::
	@ rm -f parser.cpp parser.xml parser.output
	@ rm -f $(LEVEL)/include/*.hh $(LEVEL)/include/parser.h
	@ rm -f scanner.cpp

parser.cpp:: parser.y
	$(YACC) $(YFLAGS) -o $@ $<
	@ mv *.hh $(LEVEL)/include/
	@ mv *.output *.xml $(LEVEL)/docs
# Mover arquivos de relatório para ../docs

scanner.cpp:: scanner.l
	$(LEX) $(LFLAGS) -o$@ $<

#
# Include Makefile.common so we know what to do.
#
include $(LEVEL)/Makefile.common
