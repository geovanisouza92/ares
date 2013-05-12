
LEVEL = .
DIRS = lib tools
EXTRA_DIST = include

include $(LEVEL)/Makefile.common

all-local::

pdf:: proposta tcc

tcc:: docs
	@ cd tcc; $(MAKE) tcc.pdf

proposta:: docs
	@ cd tcc; $(MAKE) proposta-pesquisa

docs::
	@ cd docs; $(MAKE) docs

test:: all-local
	@ $(LEVEL)/Release/bin/arc -x 3 `ls $(LEVEL)/tests/*.ar` 2> $@.results

use: all
	@ $(LEVEL)/Release/bin/arc -x 2

clean-local::
	@ rm -rf *.results
