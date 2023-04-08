return {
  'shaunsingh/nord.nvim',
  { 'rebelot/kanagawa.nvim', enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },

  {
    'ellisonleao/gruvbox.nvim',
    opts = {
      -- contrast = 'soft',
      transparent_mode = true,
    },
    -- config = function ()
    --   require("gruvbox").setup({
    --     contrast = "", -- can be "hard", "soft" or empty string
    --     transparent_mode = true,
    --   })
    -- end
  },

  {
    'navarasu/onedark.nvim',
    opts = {
      style = 'darker',
      transparent = true,
    }
    -- config = function ()
    --   require('onedark').setup {
    --     style = 'darker', -- dark, darker, cool, deep, warm, warmer
    --     transparent = true,
    --   }
    --   -- print("Loading onedark theme")
    -- end
  },

}
