// This tool simulates a valid channel endpoint for SUC

package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

var count = 0

func main() {
	router := httprouter.New()
	router.GET("/", post)

	log.Fatal(http.ListenAndServe(":8091", router))
}

func post(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	count++
	// if count == 1 {
	http.Redirect(w, r, "/somewhere/14052020", 302)
	fmt.Println("redirected to 14052020")
}
