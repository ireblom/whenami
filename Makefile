prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release

test:
	swift test

install: build
	install ".build/release/whenami" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/whenami"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
