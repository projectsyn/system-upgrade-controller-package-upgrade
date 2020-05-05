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
	if count == 1 {
		http.Redirect(w, r, "/somewhere/04052020", 302)
		fmt.Println("redirected to 04052020")
	} // else if count == 2 {
	// 	http.Redirect(w, r, "/somewhere/24042020", 302)
	// 	fmt.Println("redirected to 24042020")
	// } else {
	// 	http.Redirect(w, r, "/somewhere/28042020", 302)
	// 	fmt.Println("redirected to 28042020")
	// }
}
