-- Global settings for NeoVim
-- local g = vim.g
-- g.loaded_netrw = 0 -- 1 means disabled
-- g.loaded_netrwPlugin = 0 -- 1 means disabled

-- NeoVim Options
-- local o = vim.opt
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
-- vim.o.number = true
vim.o.relativenumber = true
-- vim.o.hidden = true

-- Highlight text when on yank
vim.api.nvim_create_autocmd({"TextYankPost"}, {
  pattern = "*",
  callback = function ()
    vim.highlight.on_yank({higroup="IncSearch", timeout=200})
  end
})
