package main

import (
	"crypto/rand"
	"flag"
	"fmt"
)

const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
const defaultLength = 64

// generatePassword returns a random string of length 6
func generatePassword(n int) string {
	var bytes = make([]byte, n)

	rand.Read(bytes)

	for i, b := range bytes {
		bytes[i] = chars[b%byte(len(chars))]
	}

	return string(bytes)
}

func main() {
	length := flag.Int("length", defaultLength, "password length")
	flag.Parse()
	fmt.Printf("%s\n", generatePassword(*length))
}
