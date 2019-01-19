all:gen_go gen_dart


gen_go:
	@protoc -I ./proto --go_out=pliugins=grpc:server/api ./proto/*.proto

gen_dart:
	@protoc -I ./proto --dart_out=grpc:client/lib/api ./proto/*.proto

start_go_server:
	@cd server/cmd/server && go build && ./server

install_dependencies:
	@cd server && dep ensure
	 
