##===- projects/sample/lib/sample/Makefile -----------------*- Makefile -*-===##

#
# Indicate where we are relative to the top of the source tree.
#
LEVEL=../..

#
# Give the name of a library.  This will build a dynamic version.
#
LIBRARYNAME=parser

#
# Include Makefile.common so we know what to do.
#
include $(LEVEL)/Makefile.common

# Dependencies
YACC = bison

YFLAGS += -v -x --defines=$(LEVEL)/include/parser.h

ifeq ($(DEBUG_SYMBOLS),1)
YFLAGS += --debug
endif

parser.cpp: parser.yacc
	$(YACC) $(YFLAGS) -o $@ parser.yacc
	mv *.hh $(LEVEL)/include/
