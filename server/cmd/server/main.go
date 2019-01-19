package main

import (
	"fluttergrpc/server/pkg/server"
	"fluttergrpc/server/pkg/util"
)

func main() {
	server := server.New()
	util.OnExit(server.Close)
	if err := server.Serve(); err != nil {
		panic(err)
	}
}
