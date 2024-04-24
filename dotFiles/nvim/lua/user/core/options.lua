-- Global settings for NeoVim
vim.opt.termguicolors = true
ColorScheme = 'catppuccin-mocha'
if vim.env.NVCS then
  ColorScheme = vim.env.NVCS
end
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
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
-- Do not highligh search item
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
-- vim.o.hidden = true
vim.o.listchars = 'eol:$,tab:>-,trail:~,extends:>,precedes:<,nbsp:+'
vim.opt.mouse = nil
-- Disable providers
vim.g.loaded_python3_provider = 0;
vim.g.loaded_ruby_provider = 0;
vim.g.loaded_node_provider = 0;
vim.g.loaded_perl_provider = 0;
-- Start netrw in tree style
vim.g.netrw_liststyle = 3

Jdtl_auto_start = true

-- Highlight text when on yank
vim.api.nvim_create_autocmd({"TextYankPost"}, {
  pattern = "*",
  callback = function ()
    vim.highlight.on_yank({higroup="IncSearch", timeout=200})
  end
})