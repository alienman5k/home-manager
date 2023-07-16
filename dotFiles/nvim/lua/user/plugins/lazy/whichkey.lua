return {
  -- WhichKey
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wc = require('which-key')
      wc.setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
      wc.register({
        b = { name = "Buffer" },
        -- c = { name = "Code" },
        -- d = { name = "Debug" },
        f = { name = "File" },
        h = { name = "Help" },
        w = { name = "Window" },
        ['<Tab>'] = { name = 'Tabs'}
        -- z = { name = "Fold" },
      }, { prefix = "<leader>" })
    end,
  },
}
