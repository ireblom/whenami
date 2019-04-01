prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release

test: build
	swift test -c release

install: build
	install ".build/release/whenami" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/whenami"

clean:
	rm -rf .build

.PHONY: build test install uninstall clean
