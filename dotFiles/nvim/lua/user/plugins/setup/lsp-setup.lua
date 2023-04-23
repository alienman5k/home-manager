local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local M = {}

M.lsp_setup = function ()
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
  }

  -- Configuration for RUST
  lspconfig.rust_analyzer.setup{
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = true;
        }
      }
    }
  }

  lspconfig.nil_ls.setup({})

  --TODO - move JDTLS initialization here instead of java.lua by adding auto cmd for filetype
  -- vim.api.nvim_create_augroup("JdtlsGroup")

end


M.dap_setup = function()
  local okduw, widgets = pcall(require, 'dap.ui.widgets')
  if not okduw then
    print('dap.ui.widgets not loaded')
    return
  end

  local opts = { buffer = 0, noremap = true, silent = true }
  -- Mappings
  -- local widgets = require('dap.ui.widgets')
  local okwk, wc = pcall(require, 'which-key')
  if okwk then
    -- print("register which-key for dap")
    wc.register({
      ["<leader>d"] = { name = "+Debugger" }
    })
  end

  local map = vim.keymap.set

  -- print('Configuring dap_setup')

  map('n', '<leader>dk', widgets.hover, { desc = 'Show Expression' })
  -- map('n', '<leader>wk', function() widgets.cursor_float(widgets.expression).open() end, opts)
  map('n', '<leader>ds', function() widgets.centered_float(widgets.scopes).open() end,
    { buffer = 0, noremap = true, silent = true, desc = 'Show Scopes' })
  map('n', '<leader>df', function() widgets.centered_float(widgets.frames).open() end, { desc = 'Show Frames' })
  map('n', '<leader>dt', function() widgets.centered_float(widgets.threads).open() end, opts, { desc = 'Show Threads' })

  -- print('End dap_setup')
end

return M
