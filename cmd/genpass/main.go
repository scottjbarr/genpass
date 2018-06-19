package main

import (
	"flag"
	"fmt"

	"github.com/scottjbarr/genpass"
)

func main() {
	length := flag.Int64("length", genpass.DefaultLength, "password length")
	flag.Parse()

	fmt.Printf("%s\n", genpass.Generate(*length))
}
