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

xcodeproj:
	swift package generate-xcodeproj

clean:
	rm -rf .build

distclean: clean
	rm -rf whenami.generate-xcodeproj

.PHONY: build test install uninstall xcodeproj clean distclean
