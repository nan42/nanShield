clean_list += $(wildcard *.out)
clean_list += .venv

.PHONY: all clean test coverage generate

all: test

test:
	busted

clean:
	@- $(RM) -rf $(clean_list)

coverage: clean
	busted --coverage
	luacov

generate: .venv pkg/absorbdb.lua

pkg/absorbdb.lua: .dbcache tools/absorbdb.yaml
	( . .venv/bin/activate && \
	  wowdb-query -c tools/absorbdb.yaml -o pkg/absorbdb.lua absorbdb)

.dbcache:
	mkdir .dbcache

.venv:
	( virtualenv .venv && \
	  . .venv/bin/activate && \
	  pip install git+ssh://git@github.com/nan-gameware/nan-wa-utils)
