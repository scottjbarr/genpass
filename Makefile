GO ?= go

# command to build and run on the local OS.
GO_BUILD = go build

# command to compiling the distributable. Specify GOOS and GOARCH for
# the target OS.
GO_DIST_LINUX = GOOS=linux GOARCH=amd64
GO_DIST = CGO_ENABLED=0 $(GO_BUILD) -a -tags netgo -ldflags '-w'

# port to listen on for the container and/or binary
PORT ?= 5000

.PHONY: dist

all: clean build

deps:
	go get -t ./...

dist: test prepare dist-http dist-cli

# builds the http server for linux as that is the only deployment target
dist-http: prepare
	$(GO_DIST_LINUX) $(GO_DIST) -o dist/linux/genpass-http cmd/genpass-http/main.go

# builds the cli for all useful targets
dist-cli: prepare dist-cli-linux dist-cli-darwin-intel dist-cli-darwin-m1

dist-cli-linux:
	$(GO_DIST_LINUX) $(GO_DIST) -o dist/linux/genpass cmd/genpass/main.go

dist-cli-darwin-intel:
	GOOS=darwin GOARCH=amd64 $(GO_DIST) -o dist/darwin-intel/genpass cmd/genpass/main.go

dist-cli-darwin-m1:
	GOOS=darwin GOARCH=arm64 $(GO_DIST) -o dist/darwin-m1/genpass cmd/genpass/main.go

build: test prepare
	$(GO_BUILD) -o dist/genpass-http cmd/genpass-http/main.go

prepare:
	mkdir -p dist/linux dist/darwin-intel dist/darwin-m1
	mkdir -p build

test:
	$(GO) test

run:
	PORT=$(PORT) go run cmd/genpass-http/main.go

# See https://devcenter.heroku.com/articles/container-registry-and-runtime
deploy: docker
	heroku container:push web
	heroku container:release web

docker: dist
	docker build -t genpass-http .

docker-run:
	docker run -p $(PORT):$(PORT) -e PORT=$(PORT) genpass-http

clean:
	rm -rf build dist
