GO ?= go

# command to build and run on the local OS.
GO_BUILD = go build

# command to compiling the distributable. Specify GOOS and GOARCH for
# the target OS.
GO_DIST = CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GO_BUILD) -a -tags netgo -ldflags '-w'

.PHONY: dist

all: clean build

deps:
	go get -t ./...

dist: test
	mkdir -p dist
	$(GO_DIST) -o dist/genpass-http cmd/genpass-http/main.go

build: test
	mkdir -p build
	$(GO_BUILD) -o build/queue-foo-publish cmd/queue-foo-publish/main.go
	$(GO_BUILD) -o build/queue-foo-receive cmd/queue-foo-receive/main.go

test:
	$(GO) test

docker: dist
	docker build -t genpass-http .

docker-run:
	docker run -p5000:5000 -e PORT=5000 genpass-http

clean:
	rm -rf build dist
