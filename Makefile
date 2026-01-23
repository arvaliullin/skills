.PHONY: singleton
singleton:
	- @go run github.com/arvaliullin/skills/patterns/singleton

.PHONY: prototype
prototype:
	- @go run github.com/arvaliullin/skills/patterns/prototype

.PHONY: fmt
fmt:
	- go fmt ./...
