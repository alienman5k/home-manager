ColorScheme = 'gruvbox'
vim.o.background = "dark"

require('user.core.options')
require('user.core.utils')
require('user.core.keymap')
require('user.core.statusline')
require('user.core.filetypes')
require('user.plugins.lazyvim')

-- Chage apperance if exists
vim.cmd('silent! colorscheme ' .. ColorScheme)

