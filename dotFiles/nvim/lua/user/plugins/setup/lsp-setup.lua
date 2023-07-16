local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local M = {}

-- Keymap for DAP UI
local function dap_ui_widgets_setup(bufnr)
  local widgets_loaded, widgets = pcall(require, 'dap.ui.widgets')
  if widgets_loaded then
    vim.keymap.set({ 'n', 'v' }, '<leader>k', widgets.hover,
      { buffer = bufnr, noremap = true, silent = true, desc = 'Show Expression' })
    -- map('n', '<leader>wk', function() widgets.cursor_float(widgets.expression).open() end, opts)
    vim.keymap.set('n', '<leader>ds', function() widgets.centered_float(widgets.scopes).open() end,
      { buffer = bufnr, noremap = true, silent = true, desc = 'Show Scopes' })
    -- vim.keymap.set('n', '<leader>ds', function() widgets.preview(widgets.scopes).open() end, { buffer = bufnr, noremap = true, silent = true, desc = 'Toggle Scopes' })
    vim.keymap.set('n', '<leader>df', function() widgets.centered_float(widgets.frames).open() end,
      { buffer = bufnr, noremap = true, silent = true, desc = 'Show Frames' })
    vim.keymap.set('n', '<leader>dt', function() widgets.centered_float(widgets.threads).open() end,
      { buffer = bufnr, noremap = true, silent = true, desc = 'Show Threads' })
  end
end


-- Callback function to use when an Language Server is attached to provide generic mappings for all clients
local function on_lsp_attach(ev)
  local function get_opts (desc)
    return { noremap = true, silent = true, desc = desc, buffer = ev.buf }
  end
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  -- This options apply to any buffer after LSP plugin has loaded, in order to add other keymaps for a particular server, use the on_attach property.
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, get_opts())
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, get_opts('Go to definition'))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, get_opts('Go to declaration'))
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, get_opts('Go to type'))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, get_opts('Go to implementation'))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, get_opts('References'))
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, get_opts('Code Actions'))
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, get_opts('Rename'))
  vim.keymap.set({'n', 'v'}, "<space>cf", function() vim.lsp.buf.format { async = true } end, get_opts('Format'))
  vim.keymap.set('n', '<leader>ce', vim.diagnostic.open_float, get_opts('Show diagnostic'))
  vim.keymap.set('n', '<leader>cj', vim.diagnostic.goto_next, get_opts('Next diagnostic'))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, get_opts("Next Diagnostic"))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, get_opts("Previous Diagnostic"))
  vim.keymap.set('n', '<leader>ck', vim.diagnostic.goto_prev, get_opts('Previous diagnostic'))
  vim.keymap.set('n', '<leader>cl', '<cmd>Telescope diagnostics<cr>', get_opts('Show diagnostics list'))
  vim.keymap.set("n", "<leader>fs", '<cmd>Telescope lsp_document_symbols<cr>', get_opts('Document Symbols'))
  vim.keymap.set("n", "<leader>fr", '<cmd>Telescope lsp_references<cr>', get_opts('References'))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, get_opts('Signature help'))

  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  -- print("Client name: " .. client.name)
  if client.name == "jdtls" then
    print("dap_setup for jdt.ls in lsp_setup during on_lsp_attach")
    require("jdtls").setup_dap { hotcodereplace = "auto" }
    require("jdtls.dap").setup_dap_main_class_configs()
    vim.lsp.codelens.refresh()
  end
  local okwk, wc = pcall(require, 'which-key')
  if okwk then
    wc.register({
      ["<leader>c"] = { name = "+Code" },
      ["<leader>d"] = { name = "+Debugger" }
    })
  end

  dap_ui_widgets_setup(ev.buf)
end

function M.lsp_setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = on_lsp_attach
  })

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
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = true;
        }
      }
    }
  }

  -- lspconfig.nil_ls.setup({})

  --TODO - move JDTLS initialization here instead of java.lua by adding auto cmd for filetype
  -- vim.api.nvim_create_augroup("JdtlsGroup")

end


function M.dap_setup()
  local dapui_loaded, dapui = pcall(require, 'dapui')
  if dapui_loaded then
    local dap_loaded, dap = pcall(require, 'dap')
    if dap_loaded then
      dap.listeners.after.event_initialized["dapui_config"] = function()
        -- vim.opt.mouse = "a"
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- vim.opt.mouse = nil
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- vim.opt.mouse = nil
        dapui.close()
      end
    end
  end
end

return M
