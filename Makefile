
LEVEL = .
DIRS = lib tools
EXTRA_DIST = include

include $(LEVEL)/Makefile.common

all-local:: pdf test

pdf:: proposta tcc

tcc:: docs
	@ cd tcc; $(MAKE) tcc.pdf

proposta:: docs
	@ cd tcc; $(MAKE) proposta-pesquisa

docs::
	@ cd docs; $(MAKE) docs

test::
	@ $(LEVEL)/Release/bin/arc --verbose=3 `ls $(LEVEL)/tests/*.ar` 2> $@.results

clean-local::
	@ rm -rf *.results
