return {
  -- {
  --   'shaunsingh/nord.nvim',
  --   enabled = false,
  -- },
  -- {
  --   'rebelot/kanagawa.nvim',
  --   enabled = true,
  --   opts = {
  --     transparent = false,
  --     statementStyle = { bold = false },
  --   },
  -- },
  {
    'catppuccin/nvim',
    name = "catppuccin",
    enabled = true,
    opts = {
      transparent_background = false,
    }
  },
  {
    'ellisonleao/gruvbox.nvim',
    enabled = true,
    opts = {
      -- contrast = 'soft',
      transparent_mode = false,
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
    enabled = true,
    opts = {
      style = 'darker',
      transparent = false,
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
