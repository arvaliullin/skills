.PHONY: venv
venv:
	@python3 -m venv .env

.PHONY: activate
activate:
	@source .env/bin/activate

.PHONY: freeze
freeze:
	@pip freeze > requirements.txt

.PHONY: install
install:
	@pip install -r requirements.txt

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
