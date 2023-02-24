local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


require('packer').startup({function(use)
  use 'wbthomason/packer.nvim' -- Package Manager
  use {'glepnir/dashboard-nvim', disable = true} --Nice dashboard as intro page

  use {
    'neovim/nvim-lspconfig', -- Configurations for Nvim LSP
    {'mfussenegger/nvim-dap'}, -- LSP Debugging
    {'mfussenegger/nvim-jdtls'}, -- For a more complete Java LSP Experience (Using Eclipse LSP)
  }

  -- TreeSitter for better file parsing and highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function ()
      require('nvim-treesitter.install').update({ with_sync = true })
    end
  }

  -- Color Schemes
  use 'shaunsingh/nord.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use 'rebelot/kanagawa.nvim'
  use {
    'phha/zenburn.nvim',
    disable = true,
    -- config = function ()
    --   require("zenburn").setup()
    -- end
  }
  use {
    'navarasu/onedark.nvim',
    -- fn = "ColorScheme",
    -- cmd = "ColorScheme",
    -- event = "ColorSchemePre",
    disable = false,
    config = function ()
      require('onedark').setup {
        style = 'darker', -- dark, darker, cool, deep, warm, warmer
        transparent = true,
      }
      -- print("Loading onedark theme")
    end
  }
  -- use 'almo7aya/neogruvbox.nvim'
  use {
    'NTBBloodbath/doom-one.nvim',
     disable = true,
     setup = function()
       vim.g.doom_one_plugin_neorg = false -- To avoid errors while loading due to Neorg not installed
     end
  }
  use { "catppuccin/nvim", as = "catppuccin" }

  -- ModLine
  use {
    'nvim-lualine/lualine.nvim',
    event = "VimEnter",
    disable = true,
    -- options = {
    --   theme = 'auto',
    --   globalstatus = true,
    -- }
  }

  -- Ledger files
  use {
    'ledger/vim-ledger',
    disable = true,
    ft = { 'dat', 'ledger' }
  }

  -- Fuzzy Finder
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
-- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Auto Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
    --'hrsh7th/cmp-cmdline',
      'onsails/lspkind.nvim',
    }
  }

  use "L3MON4D3/LuaSnip"
  use {
    'numToStr/Comment.nvim',
    disable = false,
    event = "BufWinEnter",
    config = function()
      require('Comment').setup()
    end
  }

  use {
    "NTBBloodbath/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" }
  }

  -- Terminal
  use {
    "akinsho/toggleterm.nvim",
    tag = '2.3.0'
  }

  -- use {
  --   'kyazdani42/nvim-tree.lua',
  --   disable = true,
  --   requires = {
  --     'kyazdani42/nvim-web-devicons', -- optional, for file icons
  --   },
  --   tag = 'nightly' -- optional, updated every week. (see issue #1193)
  -- }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = require('packer.util').float, -- Display packer in a floating window
  },
  profile = {
    enable = true,
    threshold = 1, -- the amount in ms that a plugin's load time must be over for it to be included in the profile
  }
}})

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
