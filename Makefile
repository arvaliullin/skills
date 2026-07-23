.PHONY: sync
sync:
	@uv sync

.PHONY: singleton
singleton:
	- @go run github.com/arvaliullin/skills/patterns/singleton

.PHONY: prototype
prototype:
	- @go run github.com/arvaliullin/skills/patterns/prototype

.PHONY: builder
builder:
	- @go run github.com/arvaliullin/skills/patterns/builder

.PHONY: opts
opts:
	- @go run github.com/arvaliullin/skills/patterns/opts

.PHONY: factory
factory:
	- @mkdir -p bin
	- @g++ -o bin/factory patterns/factory/main.cpp
	- @./bin/factory

.PHONY: fmt
fmt:
	- go fmt ./...
	- @find . -name "*.cpp" -o -name "*.hpp" -o -name "*.h" | xargs clang-format -i

.PHONY: up
up:
	@docker compose -f deployments/docker-compose.yml up -d

.PHONY: down
down:
	@docker compose -f deployments/docker-compose.yml down

.PHONY: logs
logs:
	@docker compose -f deployments/docker-compose.yml logs -f

.PHONY: ps
ps:
	@docker compose -f deployments/docker-compose.yml ps
