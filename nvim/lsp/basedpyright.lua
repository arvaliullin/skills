return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "uv.lock" },
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  before_init = function(_, config)
    local root = config.root_dir
    if not root then
      return
    end
    local python = root .. "/.venv/bin/python"
    if vim.fn.executable(python) == 1 then
      config.settings = vim.tbl_deep_extend("force", config.settings, {
        python = { pythonPath = python },
      })
    end
  end,
}
