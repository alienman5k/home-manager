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
}
