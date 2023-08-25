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
        b = { name = "Buffers" },
        -- c = { name = "Code" },
        -- d = { name = "Debug" },
        f = { name = "Find" },
        h = { name = "Help" },
        -- w = { name = "Window" },
        ['<Tab>'] = { name = 'Tabs'}
        -- z = { name = "Fold" },
      }, { prefix = "<leader>" })
      -- Below is register on LSP Attach to make it local to the buffer
      -- wc.register({
      --   c = { name = "Code" },
      --   d = { name = "Debug" },
      -- }, { prefix = "<localleader>" })
    end,
  },
}
