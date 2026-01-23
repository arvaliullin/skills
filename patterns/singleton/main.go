// Singleton
// Одиночка - это порождающий паттерн,
// который гарантирует, что существует только один объект определённого типа,
// и даёт глобальный доступ к этому объекту.
package main

import (
	"fmt"
	"sync"
)

var (
	instance *Instance
	once     sync.Once
)

type Instance struct {
}

func getInstance() *Instance {

	once.Do(func() {
		instance = &Instance{}
	})

	return instance
}

func main() {
	for i := range 10 {
		fmt.Printf("%d, %p\n", i, getInstance())
	}
}
