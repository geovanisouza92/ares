
LEVEL=../..
LIBRARYNAME = ares

FLEX = flex
BISON = bison
FFLAGS +=
BFLAGS += -v -x

all-local:: parser.cpp scanner.cpp

clean-local::
	@ rm -f parser.cpp
	@ rm -f scanner.cpp
	@ rm -f $(LEVEL)/include/*.hh
	@ rm -f $(LEVEL)/include/parser.h

parser.cpp:: parser.y
	@ $(BISON) $(BFLAGS) --defines=parser.h -o $@ $<
	@ mv parser.h $(LEVEL)/include/
	@ mv *.hh $(LEVEL)/include/
	@ mv *.output $(LEVEL)/docs
	@ mv *.xml $(LEVEL)/docs
	@ $(MAKE) all-local

scanner.cpp:: scanner.l
	@ $(FLEX) $(FFLAGS) -o$@ $<
	@ $(MAKE) all-local

include $(LEVEL)/Makefile.common
