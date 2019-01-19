package util

import (
	"context"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/pkg/errors"

	"google.golang.org/grpc/peer"
)

func OnExit(cleanups ...func()) {
	go onExit(cleanups...)

}

func onExit(cleanups ...func()) {
	ch := make(chan os.Signal)
	signal.Notify(ch, os.Interrupt, syscall.SIGTERM)
	<-ch
	for _, cleanup := range cleanups {
		cleanup()
	}
}

func GetIpaddrFromCtx(ctx context.Context) (string, error) {
	p, ok := peer.FromContext(ctx)
	if !ok {
		return "", errors.New("got no peer info")
	}
	addr := p.Addr.String()
	host, _, err := net.SplitHostPort(addr)
	if err != nil {
		return "", errors.Errorf("invalid ipaddr:%s", addr)
	}
	return host, nil
}
