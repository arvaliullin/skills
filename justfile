set shell := ["powershell", "-NoLogo", "-Command"]

sync:
    @uv sync; exit $LASTEXITCODE

install-deps:
    go install golang.org/x/tools/gopls@latest; exit $LASTEXITCODE
    go install github.com/go-delve/delve/cmd/dlv@latest; exit $LASTEXITCODE
    go install github.com/charmbracelet/glow@latest; exit $LASTEXITCODE

singleton:
    -@go run github.com/arvaliullin/skills/patterns/singleton; exit $LASTEXITCODE

prototype:
    -@go run github.com/arvaliullin/skills/patterns/prototype; exit $LASTEXITCODE

builder:
    -@go run github.com/arvaliullin/skills/patterns/builder; exit $LASTEXITCODE

opts:
    -@go run github.com/arvaliullin/skills/patterns/opts; exit $LASTEXITCODE

factory:
    @cmake -S . -B build; exit $LASTEXITCODE
    @cmake --build build --target factory; exit $LASTEXITCODE
    @./bin/factory; exit $LASTEXITCODE

fmt:
    -go fmt ./...; exit $LASTEXITCODE
    -@Get-ChildItem -Recurse -File | Where-Object { $_.Extension -in '.cpp', '.hpp', '.h' } | ForEach-Object { clang-format -i $_.FullName }

up:
    @docker compose -f deployments/docker-compose.yml up -d; exit $LASTEXITCODE

down:
    @docker compose -f deployments/docker-compose.yml down; exit $LASTEXITCODE

logs:
    @docker compose -f deployments/docker-compose.yml logs -f; exit $LASTEXITCODE

ps:
    @docker compose -f deployments/docker-compose.yml ps; exit $LASTEXITCODE
