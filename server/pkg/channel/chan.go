package channel

import (
	"errors"
	"sync/atomic"
)

var (
	ErrClosed = errors.New("channel closed")
)

type Channel struct {
	sendCh chan interface{}
	doneCh chan struct{}
	closed uint32
}

func New() *Channel {
	return &Channel{sendCh: make(chan interface{}), doneCh: make(chan struct{})}
}

func (c *Channel) Send(req interface{}) error {
	if atomic.LoadUint32(&c.closed) == 1 {
		return ErrClosed
	}
	select {
	case c.sendCh <- req:
	case <-c.doneCh:
		c.sendCh = nil
		return ErrClosed
	}
	return nil
}

func (c *Channel) Recv() (interface{}, error) {
	select {
	case req := <-c.sendCh:
		return req, nil
	case <-c.doneCh:
		return nil, ErrClosed
	}
}
func (c *Channel) Close() {
	atomic.StoreUint32(&c.closed, 1)
	close(c.doneCh)
}
