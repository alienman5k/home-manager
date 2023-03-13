local function cmp_setup()
  local ok, cmp = pcall(require, "cmp")
  if not ok or cmp == nil then
    return
  end
  cmp.setup({
    snippet = {
      -- required - you must specify a snippet engine
      expand = function(args)
        --vim.fn["vsnip#anonymous"](args.body) -- for `vsnip` users.
        require("luasnip").lsp_expand(args.body) -- for `luasnip` users.
        -- require("snippy").expand_snippet(args.body) -- for `snippy` users.
        -- vim.fn["ultisnips#anon"](args.body) -- for `ultisnips` users.
      end,
    },
    formatting = {
      format = require("lspkind").cmp_format {
        with_text = true,
        menu = {
          buffer = "[buf]",
          nvim_lsp = "[lsp]",
          nvim_lua = "[api]",
          path = "[path]",
          luasnip = "[snip]",
          -- gh_issues = "[issues]",
          -- tn = "[tabnine]",
        },
      },
    },
    mapping = cmp.mapping.preset.insert({
      ["<c-b>"] = cmp.mapping.scroll_docs(-4),
      ["<c-f>"] = cmp.mapping.scroll_docs(4),
      ["<c-space>"] = cmp.mapping.complete(),
      ["<c-e>"] = cmp.mapping.abort(),
      ["<cr>"] = cmp.mapping.confirm({ select = true }), -- accept currently selected item. set `select` to `false` to only confirm explicitly selected items.
      ["<c-n>"] = {
        c = function(fallback)
          local _cmp = require("cmp")
          if _cmp and _cmp.visible() then
            _cmp.select_next_item()
          else
            fallback()
          end
        end,
      },
      ["<c-p>"] = {
        c = function(fallback)
          local _cmp = require("cmp")
          if _cmp and _cmp.visible() then
            _cmp.select_prev_item()
          else
            fallback()
          end
        end,
      },
    }),
    sources = cmp.config.sources({
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer", keyword_length = 3 },
      { name = "path" },
    }),
  })
end

local function lsp_setup()
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok then
    return
  end

  local function get_opts (desc)
    return { noremap = true, silent = true, desc = desc }
  end

  -- This options apply to any buffer after LSP plugin has loaded, in order to add other keymaps for a particular server, use the on_attach property.
  local map = vim.keymap.set
  map('n', 'K', vim.lsp.buf.hover, get_opts())
  map('n', 'gd', vim.lsp.buf.definition, get_opts('Go to definition'))
  map("n", "gD", vim.lsp.buf.declaration, get_opts('Go to declaration'))
  map('n', 'gt', vim.lsp.buf.type_definition, get_opts('Go to type'))
  map('n', 'gi', vim.lsp.buf.implementation, get_opts('Go to implementation'))
  map("n", "gr", vim.lsp.buf.references, get_opts('References'))
  map('n', '<leader>ca', vim.lsp.buf.code_action, get_opts('Code Actions'))
  map('n', '<leader>cr', vim.lsp.buf.rename, get_opts('Rename'))
  map({'n', 'v'}, "<space>cf", function() vim.lsp.buf.format { async = true } end, get_opts('Format'))
  map('n', '<leader>ce', vim.diagnostic.open_float, get_opts('Show diagnostic'))
  map('n', '<leader>cj', vim.diagnostic.goto_next, get_opts('Next diagnostic'))
  map('n', '<leader>ck', vim.diagnostic.goto_prev, get_opts('Previous diagnostic'))
  map('n', '<leader>cl', '<cmd>Telescope diagnostics<cr>', get_opts('Show diagnostics list'))
  map("n", "<leader>fs", '<cmd>Telescope lsp_document_symbols<cr>', get_opts('Document Symbols'))
  map("n", "<leader>fr", '<cmd>Telescope lsp_references<cr>', get_opts('References'))
  map("n", "<C-k>", vim.lsp.buf.signature_help, get_opts('Signature help'))
  -- map('i', '<C-c>', vim.lsp.buf.completion, get_opts('Buffer completion'))

  -- WIP
  -- local on_attach_lsp_lua = function(client, bufnr)
  --   -- Enable completion triggered by <c-x><c-o>
  --   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  --   -- Mappings.
  --   -- See `:help vim.lsp.*` for documentation on any of the below functions
  --   local bufopts = { noremap = true, silent = true, buffer = bufnr }
  --   vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  --   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = 'Go to declaration', unpack(bufopts) })
  --   vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = 'Go to definition', unpack(bufopts) })
  --   vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = 'Go to implementation', unpack(bufopts) })
  --   vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = 'Signature help', unpack(bufopts) })
  --   vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder,
  --     { desc = 'Add folder to workspace', unpack(bufopts) })
  --   vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder,
  --     { desc = 'Remove folder from workspace', unpack(bufopts) })
  --   vim.keymap.set("n", "<space>wl", function()
  --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --   end, { desc = 'List workspace folers', unpack(bufopts) })
  --   vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  --   vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { desc = 'Rename', unpack(bufopts) })
  --   vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { desc = 'Actions', unpack(bufopts) })
  --   vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = 'References', unpack(bufopts) })
  --   vim.keymap.set({'n', 'v'}, "<space>cf", function() vim.lsp.buf.format { async = true } end,
  --     { desc = 'Format', unpack(bufopts) })
  -- end

  -- Configuration applies only to Lua LSP
  lspconfig.lua_ls.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
      capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    },
    -- on_attach = on_attach_lsp
    -- on_attach = function()
    --   local bufmap = vim.keymap.set
    --   local bufopts = {buffer = 0}
    --   bufmap("n", "K", vim.lsp.buf.hover, bufopts)
    --   bufmap("n", "<leader>la", vim.lsp.buf.code_action, bufopts)
    --   bufmap("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
    --   bufmap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, bufopts)
    -- end
  }

  -- Configuration for RUST
  lspconfig.rust_analyzer.setup{
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = false;
        }
      }
    }
  }

end

local function dap_setup()
  local ok, widgets = pcall(require, 'dap.ui.widgets')
  if not ok then
    print('dap.ui.widgets not loaded')
    return
  end

  local opts = { buffer = 0, noremap = true, silent = true }
  -- Mappings
  -- local widgets = require('dap.ui.widgets')
  local ok, wc = pcall(require, 'which-key')
  if ok then
    print("register which-key for dap")
    wc.register({
      ["<leader>d"] = { name = "+Debugger" }
    })
  end

  local map = vim.keymap.set

  print('Configuring dap_setup')

  map('n', '<leader>dk', widgets.hover, { desc = 'Show Expression' })
  -- map('n', '<leader>wk', function() widgets.cursor_float(widgets.expression).open() end, opts)
  map('n', '<leader>ds', function() widgets.centered_float(widgets.scopes).open() end,
    { buffer = 0, noremap = true, silent = true, desc = 'Show Scopes' })
  map('n', '<leader>df', function() widgets.centered_float(widgets.frames).open() end, { desc = 'Show Frames' })
  map('n', '<leader>dt', function() widgets.centered_float(widgets.threads).open() end, opts, { desc = 'Show Threads' })

  print('End dap_setup')
end

-- End configuration for ide related plugins

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
  -- Language Server Protocol default configurations for Neovim
  {
    "neovim/nvim-lspconfig", -- Configurations for Nvim LSP
    dependencies = {
      -- "mfussenegger/nvim-dap", -- LSP Debugging
      -- "mfussenegger/nvim-jdtls", -- For a more complete Java LSP Experience (Using Eclipse LSP)
      {
        "mfussenegger/nvim-dap", -- LSP Debugging
        -- dependencies = "rcarriga/nvim-dap-ui",
        config = function()
          -- dap_setup()
        end
      },
      {
        "mfussenegger/nvim-jdtls", -- For a more complete Java LSP Experience (Using Eclipse LSP)
        -- ft = "java",
      },
    },
    config = function()
      -- require("user.lspconf")
      lsp_setup()
    end
  },
  -- Auto completion of words
  {
    "hrsh7th/nvim-cmp",
    -- event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      --"hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
    },
    config = function()
      cmp_setup()
    end
  },
  -- End Completion
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    event = "BufWinEnter"
  },
}
