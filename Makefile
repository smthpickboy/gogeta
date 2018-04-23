GO=go

SRC = $(shell find . -type f -name '*.go' -not -path "./vendor/*")

VERSION := v0.1.0
BUILD := `git rev-parse --short HEAD`
TARGETS := gogeta
project= github.com/smthpickboy/gogeta

all: check build

build: $(TARGETS) $(TEST_TARGETS)

$(TARGETS): $(SRC)
	$(GO) build $(project)

.PHONY: clean all build check image

lint: check
	@gometalinter --config=.gometalint ./...

packages = $(shell go list ./...|grep -v /vendor/)
test: check
	$(GO) test ${packages}

cov: check
	gocov test $(packages) | gocov-html > coverage.html

check:
	@$(GO) tool vet ${SRC}

clean:
	rm -f $(TARGETS)

hook:
	find .githooks -type f -exec ln -sf ../../{} .git/hooks/ \;
