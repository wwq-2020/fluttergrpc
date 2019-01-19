package server

import (
	"fluttergrpc/server/api"
	"fluttergrpc/server/pkg/conf"
	"fluttergrpc/server/pkg/service"

	"github.com/Sirupsen/logrus"
	"google.golang.org/grpc"

	"net"
)

type server struct {
	ln         net.Listener
	grpcServer *grpc.Server
}

func New() *server {
	ln, err := net.Listen("tcp", conf.GetAddr())
	if err != nil {
		panic(err)
	}
	grpcServer := grpc.NewServer()
	service := service.New()
	api.RegisterChatServer(grpcServer, service)
	return &server{ln: ln, grpcServer: grpcServer}
}

func (s *server) Serve() error {
	logrus.Infof("listtening on:%s", s.ln.Addr().String())
	if err := s.grpcServer.Serve(s.ln); err != nil {
		return err
	}
	return nil
}

func (s *server) Close() {
	s.grpcServer.Stop()
}
