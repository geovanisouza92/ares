
LEVEL = .
DIRS = lib tools docs tcc
EXTRA_DIST = include

include $(LEVEL)/Makefile.common

tcc::
	@ cd tcc; $(MAKE) tcc.pdf

docs::
	@ cd docs; $(MAKE) docs

test::
	@ $(LEVEL)/Release/bin/arc `ls $(LEVEL)/tests/*.ar`
