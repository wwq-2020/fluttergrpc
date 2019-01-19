package conf

var cfg Config

const (
	defaultAddr string = ":8081"
)

type Config struct {
	Addr string `toml:"addr`
}

func GetAddr() string {
	if cfg.Addr == "" {
		return defaultAddr
	}
	return cfg.Addr
}
