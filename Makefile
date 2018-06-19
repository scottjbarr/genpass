GO ?= go

# command to build and run on the local OS.
GO_BUILD = go build

# command to compiling the distributable. Specify GOOS and GOARCH for
# the target OS.
GO_DIST = CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GO_BUILD) -a -tags netgo -ldflags '-w'

# port to listen on for the container and/or binary
PORT ?= 5000

.PHONY: dist

all: clean build

deps:
	go get -t ./...

dist: test prepare
	$(GO_DIST) -o dist/genpass-http cmd/genpass-http/main.go

build: test prepare
	$(GO_BUILD) -o dist/genpass-http cmd/genpass-http/main.go

prepare:
	mkdir -p dist
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
