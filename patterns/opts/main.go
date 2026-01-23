// Functional options
package main

import "fmt"

type Object struct {
	Mode int
	Path string
}

type OptionFunc func(*Object)

func WithMode(mode int) OptionFunc {
	return func(o *Object) {
		o.Mode = mode
	}
}

func WithPath(path string) OptionFunc {
	return func(o *Object) {
		o.Path = path
	}
}

func NewObject(opts ...OptionFunc) *Object {
	o := &Object{}

	for _, opt := range opts {
		opt(o)
	}

	return o
}

func main() {
	o := NewObject(WithMode(10), WithPath(`root`))
	fmt.Println(o)
}
