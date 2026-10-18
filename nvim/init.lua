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
