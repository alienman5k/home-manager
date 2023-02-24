ColorScheme = 'gruvbox'
vim.o.background = "dark"

require('user.options')
require('user.keymap')
-- require('user.packer')
require('user.lazyvim')
require('user.statusline')
require('user.filetypes')

-- Chage apperance if exists
vim.cmd('silent! colorscheme ' .. ColorScheme)

