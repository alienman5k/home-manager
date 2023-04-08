return {
  -- Display a terminal in a popup window
  {
    "akinsho/toggleterm.nvim",
    version = '2.3.0',
    cmd = "ToggleTerm",
    keys = {
      { "<C-\\>",  "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" }
    },
    opts = {
      open_mapping = [[<c-\>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers_color
      -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
      direction = 'float',
      float_opts = {
        border = 'curved'
      }
    },
  },
}
