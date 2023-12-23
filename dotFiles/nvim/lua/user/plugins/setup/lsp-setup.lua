local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end

local M = {}

function M.add_lsp_keymaps(bufnr)
  local function get_opts (desc)
    return { noremap = true, silent = true, desc = desc, buffer = bufnr }
  end
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  -- This options apply to any buffer after LSP plugin has loaded, in order to add other keymaps for a particular server, use the on_attach property.
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, get_opts())
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, get_opts('Go to definition'))
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, get_opts('Go to declaration'))
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, get_opts('Go to type'))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, get_opts('Go to implementation'))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, get_opts('References'))
  vim.keymap.set('n', '<localleader>a', vim.lsp.buf.code_action, get_opts('Code Actions'))
  vim.keymap.set('n', '<localleader>r', vim.lsp.buf.rename, get_opts('Rename'))
  vim.keymap.set({'n', 'v'}, '<localleader>f', function() vim.lsp.buf.format { async = true } end, get_opts('Format'))
  -- vim.keymap.set('n', '<localleader>le', vim.diagnostic.open_float, get_opts('Show diagnostic'))
  -- vim.keymap.set('n', '<localleader>lj', vim.diagnostic.goto_next, get_opts('Next diagnostic'))
  -- vim.keymap.set('n', '<localleader>lk', vim.diagnostic.goto_prev, get_opts('Previous diagnostic'))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, get_opts('Next Diagnostic'))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, get_opts('Previous Diagnostic'))
  vim.keymap.set('n', '<localleader>ll', '<cmd>Telescope diagnostics<cr>', get_opts('Diagnostic [L]ist'))
  vim.keymap.set('n', '<localleader>ls', '<cmd>Telescope lsp_document_symbols<cr>', get_opts('Document [S]ymbols'))
  vim.keymap.set('n', '<localleader>lr', '<cmd>Telescope lsp_references<cr>', get_opts('[R]eferences'))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, get_opts('Signature help'))

  M.add_dap_keymaps(bufnr)
end

-- Callback function to use when an Language Server is attached to provide generic mappings for all clients
local function on_lsp_attach(ev)
  M.add_lsp_keymaps(ev.buf)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  -- print('Client name: ', client.name)
  if client.name == 'jdtls' then
    -- print('dap_setup for jdt.ls in lsp_setup during on_lsp_attach')
    require('jdtls').setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()
    vim.lsp.codelens.refresh()
  end

  -- Add WhichKey integration
  local wc_loaded, wc = pcall(require, 'which-key')
  if wc_loaded then
    wc.register({
      -- ['<localleader>c'] = { name = '+Code' }, -- Added in jdtls-setup
      ['<localleader>d'] = { name = '+Debugger' },
      ['<localleader>l'] = { name = '+Telescope [L]SP' },
    }, {buffer = ev.buf})
  end
end

function M.lsp_setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = on_lsp_attach
  })

  local m_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Configuration applies only to Lua LSP
  lspconfig.lua_ls.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
      capabilities = m_capabilities,
    },
  }

  -- Configuration for RUST
  lspconfig.rust_analyzer.setup{
    capabilities = m_capabilities,
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = true
        },
        check = {
          command = 'clippy'
        }
      }
    }
  }

  lspconfig.jsonls.setup({
    capabilities = m_capabilities,
    cmd = { "vscode-json-languageserver", "--stdio" }
  })

  local servers = { 'tsserver', 'nil_ls' }
  local on_attach = function (client, bufnr)
    print('Attached to client', client.name, bufnr)
  end

  for _, server in ipairs(servers) do
    lspconfig[server].setup({
      on_attach = on_attach,
      capabilities = m_capabilities
    })
  end

  -- lspconfig.nil_ls.setup({})

  --TODO - move JDTLS initialization here instead of java.lua by adding auto cmd for filetype
  -- vim.api.nvim_create_augroup('JdtlsGroup')

end

function M.add_dap_keymaps(bufnr)
  -- Add DAP Mappings
  local dap_loaded, dap = pcall(require, 'dap')
  if dap_loaded then
    vim.keymap.set('n', '<localleader>b', dap.toggle_breakpoint, { buffer = bufnr, desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<localleader>ds', dap.continue, { buffer = bufnr, desc = 'Start/Continue Debugger' })
    vim.keymap.set('n', '<localleader>di', dap.step_into, { buffer = bufnr, desc = 'Step Into' })
    vim.keymap.set('n', '<localleader>dI', dap.step_into, { buffer = bufnr, desc = 'Step Back' })
    vim.keymap.set('n', '<localleader>do', dap.step_over, { buffer = bufnr, desc = 'Step Over' })
    vim.keymap.set('n', '<localleader>dO', dap.step_out, { buffer = bufnr, desc = 'Step Out' })
        -- vim.keymap.set('n', '<localleader>dt', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<F8>', dap.continue, { buffer = bufnr, desc = 'Start/Continue Debugger' })
    vim.keymap.set('n', '<F7>', dap.step_into, { buffer = bufnr, desc = 'Step Into' })
    vim.keymap.set('n', '<S-F7>', dap.step_back, { buffer = bufnr, desc = 'Step Back' })
    vim.keymap.set('n', '<F9>', dap.step_over, { buffer = bufnr, desc = 'Step Over' })
    vim.keymap.set('n', '<S-F9>', dap.step_out, { buffer = bufnr, desc = 'Step Out' })
    -- vim.keymap.set('n', '<localleader>dc', require'dap'.continue, { buffer = bufnr, desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<localleader>dC', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { buffer = bufnr, desc = 'Set Conditional Breakpoint' })
    local dapui_loaded, dapui = pcall(require, 'dapui')
    if dapui_loaded then
      vim.keymap.set('n', '<localleader>dt', dapui.toggle, { buffer = bufnr, desc = 'See last session result' })
    end
  end
end

function M.dap_setup()
  local dap_loaded, dap = pcall(require, 'dap')
  if dap_loaded then
    local dapui_loaded, dapui = pcall(require, 'dapui')
    if dapui_loaded then
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
        vim.opt.mouse = 'a'
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
        vim.opt.mouse = nil
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
        vim.opt.mouse = nil
      end
    end
  -- Adapters
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        -- command = '/Users/imarmole/.local/share/nvim/mason/bin/codelldb', -- adjust as needed
        command = 'codelldb', -- adjust as needed
        args = {'--port', '${port}'},
      },
      name = 'codelldb',
    }
    -- Configurations
    dap.configurations.rust = {
      {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        -- args = {},
        -- runInTerminal = false,
      }
    }
  end
end

return M
