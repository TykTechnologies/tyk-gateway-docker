package main

import (
	"fmt"
	"net/http"

	"github.com/TykTechnologies/tyk/ctx"
	"github.com/TykTechnologies/tyk/headers"
	"github.com/TykTechnologies/tyk/user"
)

func getSessionByKey(key string) *user.SessionState {
	// here goes our logic to check if passed API key is valid and appropriate key session can be retrieved

	// perform auth (only one token "abc" is allowed)
	if key != "abc" {
		return nil
	}

	// return session
	return &user.SessionState{
		OrgID: "default",
		Alias: "abc-session",
	}
}

func MyPluginAuthCheck(rw http.ResponseWriter, r *http.Request) {
	// try to get session by API key
	key := r.Header.Get(headers.Authorization)
	fmt.Println("got key ", key)
	session := getSessionByKey(key)
	if session == nil {
		// auth failed, reply with 403
		rw.WriteHeader(http.StatusForbidden)
		return
	}

	// auth was successful, add session and key to request's context so other middlewares can use it
	ctx.SetSession(r, session, true)
	newSession := ctx.GetSession(r)
	fmt.Println("session", newSession)
}

func main() {}
