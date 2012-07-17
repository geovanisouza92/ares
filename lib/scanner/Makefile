##===- projects/sample/lib/sample/Makefile -----------------*- Makefile -*-===##

#
# Indicate where we are relative to the top of the source tree.
#
LEVEL=../..

#
# Give the name of a library.  This will build a dynamic version.
#
LIBRARYNAME=scanner

#
# Include Makefile.common so we know what to do.
#
include $(LEVEL)/Makefile.common

# Dependencies

LEX = flex

LFLAGS =

ifeq ($(DEBUG_SYMBOLS),1)
LFLAGS += --debug
endif

scanner.cpp: scanner.lex
	$(LEX) $(LFLAGS) -o$@ scanner.lex
