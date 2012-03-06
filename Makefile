
DEBUG_MODE=1
USE_CLANG=1

ifeq ($(DEBUG_MODE),1)
DEFAULT_CXXFLAGS=-Wall -gstabs
PFLAGS=-pg
else
DEFAULT_CXXFLAGS=-Wall
PFLAGS=
endif

BOOST_LIB=../boost_1_48_0/bin.v2/libs
BOOST_TAIL=build/gcc-4.6.1/release/link-static/threading-multi
BOOST_PO=$(BOOST_LIB)/program_options/$(BOOST_TAIL)/*.o
BOOST_SYS=$(BOOST_LIB)/system/$(BOOST_TAIL)/error_code.o
BOOST_FS= \
  $(BOOST_LIB)/filesystem/$(BOOST_TAIL)/v3/src/path.o \
  $(BOOST_LIB)/filesystem/$(BOOST_TAIL)/v3/src/operations.o \
  $(BOOST_SYS)

ifeq ($(USE_CLANG),1)
CXX=clang
CXXFLAGS=$(DEFAULT_CXXFLAGS) -xc++ -ferror-limit=2 -Wno-logical-op-parentheses
LDFLAGS=-lstdc++ $(BOOST_PO) $(BOOST_FS)
else
CXX=g++
CXXFLAGS=$(DEFAULT_CXXFLAGS)
LDFLAGS=-lstdc++ $(BOOST_PO) $(BOOST_FS) $(PFLAGS)
endif

YACC=bison
YFLAGS=--defines=parser.h -v

LEX=flex
LFLAGS=

BINARY=arc
BINFLAGS=--verbose=2
MODULES=ast.o parser.o scanner.o driver.o main.o
CLEAN=parser.cpp parser.h scanner.cpp *.hh *.out* *.results *.diff
TEST_MODULES=tests/*.ar

all: bin
	@ echo "Compile done"

parser.cpp:
	@ $(YACC) $(YFLAGS) -o $@ parser.yacc

scanner.cpp:
	@ $(LEX) $(LFLAGS) -o$@ scanner.lex

%.o: %.cpp
	@ echo "Preparing dependency:" $@
	@ $(CXX) $(CXXFLAGS) -c -o $@ $<

bin: $(MODULES)
	@ echo "Linking binary"
	@ $(CXX) $(LDFLAGS) $(MODULES) -o $(BINARY)

check:
	@ echo "Checking for binary"
	@ if !([ -e ./$(BINARY) ]); then make bin; fi

test: check
	@ echo "Starting test"
	@ ./$(BINARY) $(BINFLAGS) $(TEST_MODULES)
	@ echo "Test succeed"

stress:
	@ echo "Starting stress test mode ..."
	@ bash ./stress.sh
	@ echo "Stress test done."

verbose: check
	@ echo "Starting verbose test"
	@ ./$(BINARY) --verbose=3 $(TEST_MODULES) 2> $@.results
	@ echo "Verbose test succeed"

debug: check
	@ echo "Starting debug"
	@ gdb ./$(BINARY)

ifeq ($(DEBUG_MODE),1)
ifeq ($(USE_CLANG),0)
profile: clear stress
	@ echo "Performance analysis"
	@ gprof ./$(BINARY) ./gmon.out > $@.results
	@ echo "Profile done"
endif
endif

use: check
	@ ./$(BINARY) $(BINFLAGS)

clear:
	@ clear
	@ rm -rf $(BINARY) $(MODULES) $(CLEAN)
