// Package Паттерн Singleton
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
