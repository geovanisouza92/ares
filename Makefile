
LEVEL = .
DIRS = lib tools docs tcc
EXTRA_DIST = include

include $(LEVEL)/Makefile.common

tcc::
	@ cd tcc; $(MAKE) tcc.pdf

docs::
	@ cd docs; $(MAKE) docs

test::
	@ $(LEVEL)/Release/bin/arc --verbose=3 `ls $(LEVEL)/tests/*.ar` 2> $@.results

clean-local::
	@ rm -rf *.results
