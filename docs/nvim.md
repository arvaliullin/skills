# Neovim

Конфиг этого репозитория рассчитан на Neovim 0.11 или новее. Каталог [`nvim/`](../nvim) копируется в `~/.config/nvim`.

## Программы

На macOS через Homebrew:

```bash
brew install neovim cmake llvm
brew install go
```

`clangd` ставится вместе с LLVM и часто не попадает в `PATH`:

```bash
echo "$(brew --prefix llvm)/bin" >> ~/.zshrc   # или добавьте в PATH вручную
```

Серверы языков и отладчик Go:

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

Оба окажутся в `$(go env GOPATH)/bin` (обычно `~/go/bin`). Этот каталог тоже нужен в `PATH`, иначе Neovim не найдёт `gopls`. Delve конфиг ищет ещё и по пути `~/go/bin/dlv`.

Python (диагностика basedpyright, форматирование ruff):

```bash
brew install uv
uv tool install basedpyright
uv tool install ruff
```

Интерпретатор для проекта берётся из `.venv/bin/python` в корне репозитория.

## Конфиг

```bash
mkdir -p ~/.config
cp -R nvim ~/.config/nvim
```

Файлы `lsp/*.lua` Neovim подхватывает сам: имя файла — имя сервера (`gopls`, `clangd`, `basedpyright`, `ruff`).

На macOS поправьте `--query-driver` в `~/.config/nvim/lsp/clangd.lua`. Там должен быть компилятор, которым реально собирает CMake, а не пути Ubuntu. Узнать его:

```bash
which c++
which clang++
```

Типичные значения:

- Apple Clang: `/usr/bin/clang++`
- LLVM из Homebrew на Apple Silicon: `/opt/homebrew/opt/llvm/bin/clang++`
- GCC из Homebrew на Apple Silicon: `/opt/homebrew/bin/g++`

Пример:

```lua
cmd = { "clangd", "--query-driver=/usr/bin/clang++" },
```

Без этого флага clangd может не увидеть заголовки стандартной библиотеки (`iostream` и остальные).

## Отладка Go

Плагины ставятся в пакетный каталог Neovim, без менеджера плагинов:

```bash
pack=~/.local/share/nvim/site/pack/debugger/start
mkdir -p "$pack"
git clone --depth 1 https://github.com/mfussenegger/nvim-dap.git "$pack/nvim-dap"
git clone --depth 1 https://github.com/leoluz/nvim-dap-go.git "$pack/nvim-dap-go"
git clone --depth 1 https://github.com/rcarriga/nvim-dap-ui.git "$pack/nvim-dap-ui"
git clone --depth 1 https://github.com/nvim-neotest/nvim-nio.git "$pack/nvim-nio"
```

После этого перезапустите Neovim.

## C++

В корне репозитория `CMakeLists.txt` пишет команды компиляции в `build/compile_commands.json`. Файл `.clangd` говорит clangd читать эту базу. Сборка и запуск примера:

```bash
make factory
```

Первый запуск создаёт `build/`. Пока каталога нет, clangd не знает флаги.

## Клавиши

Пробел — это leader. Команды ниже в обычном режиме, если не сказано иное.

Файлы и запуск:

| Клавиши | Действие |
|---|---|
| `:Ex` | список файлов в текущем каталоге |
| Enter / `-` | зайти в каталог / на уровень вверх |
| `%` / `d` | новый файл / новый каталог |
| `:!go run %` | запустить текущий Go-файл |
| `:w` | сохранить |

Языковой сервер (Go, C++, Python):

| Клавиши | Действие |
|---|---|
| `gd` | определение |
| `gr` | ссылки |
| `K` | документация под курсором |
| пробел `rn` | переименовать |
| пробел `ca` | действие (для Go здесь «Add import» и Organize Imports) |
| `[d` / `]d` | предыдущая / следующая ошибка |

Сохранение форматирует буфер. Импорты Go сами не добавляются: пробел `ca`, затем пункт **Add import** или **Organize Imports**.

Отладка Go (Delve):

| Клавиши | Действие |
|---|---|
| пробел `b` | точка останова на текущей строке |
| пробел `dc` или F5 | запуск и продолжение; в меню выбрать **Debug** |
| пробел `ds` или F10 | шаг через строку |
| пробел `di` или F11 | шаг внутрь |
| пробел `do` или F12 | шаг наружу |
| пробел `du` | показать или скрыть окна отладчика |
