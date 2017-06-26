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

dist: test prepare
	$(GO_DIST) -o dist/genpass-http cmd/genpass-http/main.go

build: test prepare
	$(GO_BUILD) -o dist/genpass-http cmd/genpass-http/main.go

prepare:
	mkdir -p dist
	mkdir -p build

test:
	$(GO) test

# See https://devcenter.heroku.com/articles/container-registry-and-runtime
deploy: docker
	heroku container:push web

docker: dist
	docker build -t genpass-http .

docker-run:
	docker run -p 5000:5000 -e PORT=5000 genpass-http

clean:
	rm -rf build dist
