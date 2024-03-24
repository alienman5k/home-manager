-- IDE related plugings managed by LazyVim
return {
  -- Convert regions to comments for different file types
  {
    "numToStr/Comment.nvim",
    event = "BufWinEnter",
    config = function()
      require("Comment").setup()
    end
  },
  -- Java Decompiler
  -- {
  --   "alienman5k/jdecomp.nvim",
  --   opts = {
  --     decompiler = 'cfr'
  --   },
  -- },

  -- Auto completion of words
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      --"hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        version = "v1.*",
        event = "InsertEnter",
        config = function ()
          require("user.plugins.setup.luasnip").setup()
        end,
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        }
      },
    },
    config = function()
      require("user.plugins.setup.cmp-setup").cmp_setup()
    end
  },
  -- End Completion
  -- Breadcrumb in the winbar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = 'BufWinEnter',
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
  -- Language Servers Configurations
  {
    "neovim/nvim-lspconfig", -- Neovim collection of Language Server configurations
    config = function()
       require("user.plugins.setup.lsp-setup").lsp_setup()
    end,
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        enabled = true,
        config = function ()
          require("dapui").setup()
        end,
        dependencies = {
          -- Debug Adapter Protocol
          {
            "nvim-neotest/nvim-nio"
          },
          {
            "mfussenegger/nvim-dap", -- LSP Debugging
            enabled = true,
            config = function()
              require("user.plugins.setup.lsp-setup").dap_setup()
            end
          }
        }
      }
    }
  },
  -- LspConfig with jdtls does not implement all Java LS features, JDTLS does
  {
    "mfussenegger/nvim-jdtls", -- For a more complete Java LSP Experience (Using Eclipse LSP)
    enabled = true,
    ft = "java", -- Setup is handled when java file is open in jdtls-setup.lua
  },
}
