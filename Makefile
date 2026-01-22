.PHONY: singleton
singleton:
	- @go run github.com/arvaliullin/skills/patterns/singleton

.PHONY: fmt
fmt:
	- go fmt ./...
