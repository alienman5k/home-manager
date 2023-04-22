-- Keymap bindings
-- local map = vim.api.nvim_set_keymap -- Use local map to call nvim_set_map() function
local map = vim.keymap.set
-- nvim_set_keymap({mode}, {lhs}, {rhs}, {*opts})

-- Setting leader key to space
--vim.keymap.del({'n', 'v'}, '<Space>', {})
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- map('n', '<leader>ev', '<C-w><C-v><C-l>:e $MYVIMRC<cr><Paste>', { desc="Open configuration file in split window" })
map('n', '<leader>q', ':q<cr>', { desc = 'Quit' })
map('n', '<leader>he', ':e $MYVIMRC<cr><Paste>', { desc='Open configuration' })
map('n', '<leader>hve', '<C-w><C-v><C-l>:e $MYVIMRC<cr><Paste>', { desc='Open configuration file in split window' })
map('n', '<leader>hr', ':source $MYVIMRC<cr>', { desc='Reload configuration file' })

-- Terminal mapping
map('t', '<Esc>', '<C-\\><C-n>', {})

-- Window mapping
map('n', '<leader>ww', '<C-w>w', {})
-- map('n', '<leader>ws', '<cmd>:new<cr>', {})
map('n', '<leader>ws', '<C-w><C-s>', {})
-- map('n', '<leader>wv', '<c-w>:vnew<cr>', {})
map('n', '<leader>wv', '<C-w><C-v>', {})
map('n', '<leader>wr', '<C-w>r', {})
map('n', '<leader>wh', '<C-w>h', {})
map('n', '<leader>wj', '<C-w>j', {})
map('n', '<leader>wk', '<C-w>k', {})
map('n', '<leader>wl', '<C-w>l', {})
map('n', '<leader>wo', '<C-w>o', {}) -- Close other windows except this, alternative :only

-- Tabs
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>c', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>n', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>p', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- Buffer Mapping
map('n', '<leader>bn', '<cmd>bNext<cr>', { desc='Next Buffer' })
map('n', '<leader>bp', '<cmd>bprevious<cr>', { desc='Previous Buffer'})
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc='Close Buffer'})

-- Copy and Paste to Clipboard
map({'v', 'n'}, '<leader>y', '"+y', { desc='Copy to Clipboard' })
map('n', '<leader>Y', '"+yg_', {  })
map({'n', 'v'}, '<leader>p', '"+p', { desc='Paste from Clipboard' })
map({'v', 'n'}, '<leader>P', '"+P', { desc='' })

-- Open Explorer (netwr) on Left side
map({'n'}, '<leader>e', ':Lexplore<cr>', {  })

-- Open Lazy
map('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'Open LazyVim package manager' })
