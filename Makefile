.PHONY: singleton
singleton:
	- @go run github.com/arvaliullin/skills/patterns/singleton

.PHONY: prototype
prototype:
	- @go run github.com/arvaliullin/skills/patterns/prototype

.PHONY: builder
builder:
	- @go run github.com/arvaliullin/skills/patterns/builder

.PHONY: fmt
fmt:
	- go fmt ./...
