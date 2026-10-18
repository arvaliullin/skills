vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.signcolumn = "yes"
vim.g.mapleader = " "

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- gofmt использует табы. C++ и Python в этом репозитории пишутся пробелами.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.lsp.enable({ "gopls", "clangd", "basedpyright", "ruff" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Definition")
    map("gr", vim.lsp.buf.references, "References")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Prev diagnostic")
    map("]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, "Next diagnostic")
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({
      async = false,
      filter = function(client)
        if vim.bo.filetype == "python" then
          return client.name == "ruff"
        end
        return true
      end,
    })
  end,
})

vim.opt.makeprg = "make"

local function delve_path()
  if vim.fn.executable("dlv") == 1 then
    return "dlv"
  end
  return vim.fn.expand("~/go/bin/dlv")
end

require("dap-go").setup({
  delve = {
    path = delve_path(),
  },
})

local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticWarn", linehl = "Visual" })

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: start/continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: start/continue" })
vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Debug: step over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: step into" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Debug: step out" })
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: breakpoint" })
vim.keymap.set("n", "<leader>du", function()
  dapui.toggle()
end, { desc = "Debug: toggle UI" })
