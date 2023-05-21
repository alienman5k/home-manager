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
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function ()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "jdtls" },
      })
    end
  },
  -- Language Server Protocol default configurations for Neovim
  {
    "neovim/nvim-lspconfig", -- Configurations for Nvim LSP
    config = function()
       require("user.plugins.setup.lsp-setup").lsp_setup()
    end,
    dependencies = {
      -- "mfussenegger/nvim-dap", -- LSP Debugging
      -- "mfussenegger/nvim-jdtls", -- For a more complete Java LSP Experience (Using Eclipse LSP)
      {
        "mfussenegger/nvim-dap", -- LSP Debugging
        enabled = true,
        -- dependencies = "rcarriga/nvim-dap-ui",
        config = function()
          -- dap_setup()
          require("user.plugins.setup.lsp-setup").dap_setup()
        end
      },
      -- {
      --   "mfussenegger/nvim-jdtls", -- For a more complete Java LSP Experience (Using Eclipse LSP)
      --   enabled = true,
      --   -- ft = "java",
      -- },
    },
  },
  -- LspConfig with jdtls does not implement all Java LS features, JDTLS does
  {
    "mfussenegger/nvim-jdtls", -- For a more complete Java LSP Experience (Using Eclipse LSP)
    enabled = true,
    ft = "java",
    -- config = function ()
    --   require("jdtls-setup")
    -- end

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
    -- event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      --"hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("user.plugins.setup.cmp-setup").cmp_setup()
    end
  },
  -- End Completion
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v1.*",
    event = "BufWinEnter",
    config = function ()
      require("user.plugins.setup.luasnip").setup()
    end,
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
    }
  },
}
