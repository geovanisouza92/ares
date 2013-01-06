
LEVEL = .
DIRS = lib tools docs tcc
EXTRA_DIST = include

include $(LEVEL)/Makefile.common

all-local:: pdf test

pdf:: proposta tcc

tcc:: docs
	@ cd tcc; $(MAKE) tcc.pdf

docs::
	@ cd docs; $(MAKE) docs

test::
	@ $(LEVEL)/Release/bin/arc --verbose=3 `ls $(LEVEL)/tests/*.ar` 2> $@.results

clean-local::
	@ rm -rf *.results

proposta::
	@ cd tcc; $(MAKE) proposta.pdf; $(MAKE) proposta2.pdf
