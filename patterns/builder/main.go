// Builder
// Строитель - это порождающий паттерн проектирования,
// который позволяет пошагово создавать объекты.
package main

import "fmt"

type Object struct {
	Mode int
	Path string
}

func (o *Object) SetMode(mode int) *Object {
	o.Mode = mode
	return o
}

func (o *Object) SetPath(path string) *Object {
	o.Path = path
	return o
}

func NewObject() *Object {
	return &Object{}
}

func main() {
	o := NewObject().SetMode(10).SetPath(`root`)
	fmt.Println(o)
}
