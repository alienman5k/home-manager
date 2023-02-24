local ok, rest_nvim = pcall(require, 'rest-nvim')
if not ok then
  print 'Unable to load rest-nvim plugin'
end


vim.keymap.set('n', '<leader>rr', rest_nvim.run, { noremap = true, buffer = 0, desc = 'Run REST' })
vim.keymap.set('n', '<leader>rl', rest_nvim.last, { noremap = true, buffer = 0, desc = 'Run last REST call' })
-- vim.keymap.set('n', '<leader>rv', function() rest_nvim.run(true) end, { noremap = true, buffer = 0 })
vim.keymap.set('n', '<leader>rp', function() rest_nvim.run(true) end,
  { noremap = true, buffer = 0, desc = 'Preview REST call' })
vim.keymap.set('n', '<leader>re', function()
  vim.ui.input({ prompt = "Select env file: ", default = "", completion = "file" }, function(input)
    rest_nvim.select_env(input)
  end)
end, { noremap = true, buffer = 0, desc = 'Select env file' })
