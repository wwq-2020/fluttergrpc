package service

import (
	"context"
	"fluttergrpc/server/api"
	"fluttergrpc/server/pkg/channel"
	"fluttergrpc/server/pkg/util"

	"sync"

	"github.com/pkg/errors"
)

type service struct {
	client2Ch     map[string]*channel.Channel
	client2ChLock sync.RWMutex
}

func New() *service {
	return &service{client2Ch: make(map[string]*channel.Channel)}
}

func (s *service) Send(ctx context.Context, req *api.Message) (*api.Empty, error) {
	ipaddr, err := util.GetIpaddrFromCtx(ctx)
	if err != nil {
		return nil, errors.Wrap(err, "send")
	}
	s.client2ChLock.RLock()
	defer s.client2ChLock.RUnlock()
	ch, exist := s.client2Ch[ipaddr]
	if !exist {
		return nil, errors.Errorf("no subscriber")
	}
	req.Text = "reply to " + req.Text
	if err := ch.Send(req); err != nil {
		return nil, errors.Wrap(err, "send")
	}
	return &api.Empty{}, nil
}

func (s *service) Subscribe(req *api.Empty, stream api.Chat_SubscribeServer) error {
	ipaddr, err := util.GetIpaddrFromCtx(stream.Context())
	if err != nil {
		return errors.Wrap(err, "get ipaddr")
	}
	s.client2ChLock.Lock()
	ch := channel.New()
	s.client2Ch[ipaddr] = ch
	s.client2ChLock.Unlock()
	defer func() {
		delete(s.client2Ch, ipaddr)
		ch.Close()
	}()
	for {
		req, err := ch.Recv()
		if err != nil {
			return errors.Wrap(err, "recv from channel")
		}
		realReq, ok := req.(*api.Message)
		if !ok {
			return errors.Errorf("internel error")
		}
		if err := stream.Send(realReq); err != nil {
			return errors.Wrap(err, "send")
		}
	}
	return nil
}
