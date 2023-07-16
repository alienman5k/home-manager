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
  -- Plugin manager to install Language Servers, formatters, DAP and linters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function ()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "jdtls" },
      })
    end,
  },
  -- Language Servers Configurations
  {
    "neovim/nvim-lspconfig", -- Neovim collection of Language Server configurations
    config = function()
       require("user.plugins.setup.lsp-setup").lsp_setup()
    end,
    dependencies = {
      -- Debug Adapter Protocol
      {
        "mfussenegger/nvim-dap", -- LSP Debugging
        enabled = true,
        -- dependencies = "rcarriga/nvim-dap-ui",
        config = function()
          -- dap_setup()
          require("user.plugins.setup.lsp-setup").dap_setup()
        end,
        dependencies = {
          {
            "rcarriga/nvim-dap-ui",
            config = function ()
              require("dapui").setup()
            end
          }
        },
      },
    },
  },
  -- LspConfig with jdtls does not implement all Java LS features, JDTLS does
  {
    "mfussenegger/nvim-jdtls", -- For a more complete Java LSP Experience (Using Eclipse LSP)
    enabled = true,
    ft = "java", -- Setup is handled when java file is open in jdtls-setup.lua
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
    event = "InsertEnter",
    config = function ()
      require("user.plugins.setup.luasnip").setup()
    end,
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
    }
  },
}
