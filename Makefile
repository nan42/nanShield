clean_list += $(wildcard *.out)

.PHONY: all clean test coverage

all: test

test:
	busted

clean:
	@- $(RM) $(clean_list)

coverage: clean
	busted --coverage
	luacov
