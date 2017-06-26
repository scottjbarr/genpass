# Generate Password

A random password generator.

This repo provides a command line interface, and a HTTP service.

An instance of the HTTP service is running
on [Heroku](https://genpass-api.herokuapp.com).

## Install

    go get github.com/scottjbarr/cmd/genpass

## Usage

    $ genpass -h
    Usage of genpass:
      -length int
            password length (default 64)

    $ genpass
    cxpTW4vaddQqiFhmM0hrhXggNHqPtNByDM8MN1pVWXzbVXu2U5Po9djTTcDnK0mU

## Makefile

see the [Makefile](Makefile) for how to build and run the container.

## License

The MIT License (MIT)

Copyright (c) 2016 Scott Barr

See [LICENSE.md](LICENSE.md)
