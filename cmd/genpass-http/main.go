package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/scottjbarr/genpass"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	bind := fmt.Sprintf(":%v", port)

	http.HandleFunc("/", indexHandler)
	if err := http.ListenAndServe(bind, nil); err != nil {
		panic(err)
	}
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	length := r.URL.Query().Get("length")

	// parse the length param
	l, _ := strconv.ParseInt(length, 10, 64)
	if l == 0 {
		l = 64
	}

	fmt.Fprintf(w, "%s\n", genpass.Generate(l))
}
