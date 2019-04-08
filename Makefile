prefix ?= /usr/local
bindir = $(prefix)/bin
mandir = $(prefix)/share/man/man1

build:
	swift build -c release

test: build
	swift test -c release

install: build
	install -m 0555 ".build/release/whenami" "$(bindir)"
	install -m 0444 "Docs/whenami.1" "$(mandir)"

uninstall:
	rm -f "$(bindir)/whenami"
	rm -f "$(mandir)/whenami.1"

xcodeproj:
	swift package generate-xcodeproj

lint:
	swiftlint --strict

clean:
	rm -rf .build

distclean: clean
	rm -rf whenami.xcodeproj

.PHONY: build test install uninstall xcodeproj lint clean distclean
