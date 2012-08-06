
LEVEL=../..
LIBRARYNAME = ares

LEX = flex
YACC = bison
LFLAGS +=
YFLAGS += -v -x --defines=$(LEVEL)/include/parser.h

all-local:: parser.cpp scanner.cpp actions/actions.cpp

clean-local::
	@ rm -f parser.cpp
	@ rm -f $(LEVEL)/include/*.hh $(LEVEL)/include/parser.h
	@ rm -f scanner.cpp

parser.cpp:: parser.y
	@ $(YACC) $(YFLAGS) -o $@ $<
	@ mv *.hh $(LEVEL)/include/
	@ mv *.output *.xml $(LEVEL)/docs
	@ $(MAKE) all-local

scanner.cpp:: scanner.l
	@ $(LEX) $(LFLAGS) -o$@ $<
	@ $(MAKE) all-local

include $(LEVEL)/Makefile.common
