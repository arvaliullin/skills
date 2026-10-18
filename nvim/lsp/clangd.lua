return {
  cmd = { "clangd", "--query-driver=/usr/bin/c++,/usr/bin/g++,/usr/bin/g++-*" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", "CMakeLists.txt", ".clangd", ".clang-format", "Makefile" },
}
