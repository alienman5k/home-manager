local M = {}

function M.setup()
  require("luasnip.loaders.from_lua").lazy_load({paths = "~/.local/share/snippets/luasnip/"})
  -- require("luasnip.loaders.from_vscode").load({paths = { "~/.local/share/snippets/vscode/rust/", "~/.local/share/snippets/vscode/java/" }})
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("i", "<C-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
  vim.api.nvim_set_keymap("s", "<C-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
  vim.api.nvim_set_keymap("i", "<C-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
  vim.api.nvim_set_keymap("s", "<C-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
  -- Move this part to cmp-setup to check first if there is an active selection
  -- vim.api.nvim_set_keymap("i", "<C-l>", "<cmd>lua require'luasnip'.change_choice(1)<CR>", opts)
  -- vim.api.nvim_set_keymap("s", "<C-l>", "<cmd>lua require'luasnip'.change_choice(1)<CR>", opts)
  -- vim.api.nvim_set_keymap("i", "<C-p>", "<cmd>lua require'luasnip'.ls.change_choice(-1)<CR>", opts)
  -- vim.api.nvim_set_keymap("s", "<C-p>", "<cmd>lua require'luasnip'.ls.change_choice(-1)<CR>", opts)
  vim.api.nvim_set_keymap("i", "<C-u>", "<cmd>lua require'luasnip.extras.select_choice'()<CR>", opts)

end

return M
