return {
  {
    'catppuccin/nvim',
    name = "catppuccin",
    enabled = true,
    opts = {
      transparent_background = false,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      }
    }
  },
  {
    'ellisonleao/gruvbox.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      -- contrast = 'soft',
      transparent_mode = false,
      dim_inactive = false,
    },
  },
  {
    'navarasu/onedark.nvim',
    enabled = true,
    opts = {
      style = 'darker',
      transparent = false,
    }
  },
  {
    'folke/tokyonight.nvim',
    enabled = true,
    opts = {
      style = 'night',
      transparent = false,
      hide_inactive_statusline = false,
    }
  }
}
