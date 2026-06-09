PREFIX ?= $(HOME)/.local

.PHONY: install update test check man clean

install:
	PREFIX="$(PREFIX)" ./install.sh

update:
	PREFIX="$(PREFIX)" ./update.sh

test: check
	./tests/smoke.sh

check:
	perl -c bin/nacre
	sh -n install.sh
	sh -n update.sh
	sh -n tests/smoke.sh

man:
	mandoc -Tutf8 docs/nacre.1

clean:
	rm -rf .nacre-test-tmp
