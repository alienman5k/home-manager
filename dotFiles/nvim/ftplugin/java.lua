local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local home = os.getenv('HOME')
local jdtls_install_dir = home .. '/Software/lsp-servers/Java/jdtls-1.9.0/'
local jdtls_config_dir = home .. '/.cache/jdtls/config/'
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

 -- Define the capabilities for the LSP Client
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Define the bundles for JSTL
local bundles = {
  vim.fn.glob(home .. "/Software/lsp-servers/Java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
}
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/Software/lsp-servers/Java/vscode-java-test/server/*.jar"), "\n"))

-- Configuration to pass to the LSP Client when a Java file is open
local config = {
  cmd = {
    'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.level=ALL',
      '-noverify',
      '-Xmx1G',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', vim.fn.glob(jdtls_install_dir .. 'plugins/org.eclipse.equinox.launcher_*.jar'),
      '-configuration', jdtls_config_dir, -- Copied config_mac/config.ini here
      '-data', workspace_dir
  },
  root_dir = require('jdtls.setup').find_root({'.git', 'pom.xml', 'build.xml', 'mvnw', 'gradlew'}),
  settings = {
    java = {
     configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/Library/Java/JavaVirtualMachines/jdk1.8.0_311.jdk/Contents/Home/",
          },
          {
            name = "JavaSE-11",
            path = "/Library/Java/JavaVirtualMachines/jdk-11.0.12.jdk/Contents/Home/",
          },
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/jdk-17.0.4.1.jdk/Contents/Home/",
          },
        }
      },
      format = {
        enabled = true,
        settings = {
          url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml"
        }
      }
    }
  },
  init_options = {
    bundles = bundles
  },
  capabilities = cmp_capabilities,
  on_attach = function()
    -- print('Java LSP on attach called')
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer=0 })
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer=0 })
    -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer=0 })
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer=0 } )
    -- vim.keymap.set('n', '<leader>ej', vim.diagnostic.goto_next, { buffer=0 })
    -- vim.keymap.set('n', '<leader>ek', vim.diagnostic.goto_prev, { buffer=0 })
    -- vim.keymap.set('n', '<leader>el', '<cmd>Telescope diagnostics<cr>', { buffer=0 })
    -- vim.keymap.set('i', '<C-c>', vim.lsp.buf.completion, { buffer=0 })

    vim.keymap.set('n', '<leader>co', require'jdtls'.organize_imports, { buffer = 0, desc = 'Organize Imports' })
    vim.keymap.set('n', '<leader>cu', require'jdtls'.update_project_config, { buffer = 0 })
    vim.keymap.set('n', '<leader>cc', function() require'jdtls'.compile('full') end, { buffer = 0, desc = 'Compile' })
    vim.keymap.set('n', '<leader>cb', require'jdtls'.build_projects, { buffer = 0, desc = 'Build' })
    local wc = require('which-key')
    if wc then
      wc.register({ '<leader>ct', name = 'Test' })
    end
    vim.keymap.set('n', '<leader>ctc', require'jdtls'.test_class, { buffer = 0, desc = 'Test class' })
    vim.keymap.set('n', '<leader>ctt', require'jdtls'.test_nearest_method, { buffer = 0, desc = 'Test nearest method' })
    -- vim.keymap.set('n', '<leader>tm', require'jdtls'.test_nearest_method, { buffer = 0, desc = 'Test nearest method' })

    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.setup').add_commands()

    vim.keymap.set('n', '<leader>db', require'dap'.toggle_breakpoint, { buffer = 0, desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dc', require'dap'.continue, { buffer = 0, desc = 'Continue Debugger' })
    vim.keymap.set('n', '<leader>do', require'dap'.step_over, { buffer = 0, desc = 'Step Over' })
    vim.keymap.set('n', '<leader>di', require'dap'.step_into, { buffer = 0, desc = 'Step Into' })
    -- vim.keymap.set('n', '<leader>dc', require'dap'.continue, { buffer = 0, desc = 'Toggle Breakpoint' })

    local ok, widgets = pcall(require, 'dap.ui.widgets')
    if ok then
      vim.keymap.set({'n', 'v'}, '<leader>k', widgets.hover, { buffer = 0, noremap = true, silent = true, desc = 'Show Expression' })
      -- map('n', '<leader>wk', function() widgets.cursor_float(widgets.expression).open() end, opts)
      vim.keymap.set('n', '<leader>ds', function() widgets.centered_float(widgets.scopes).open() end, { buffer = 0, noremap = true, silent = true, desc = 'Show Scopes' })
      -- vim.keymap.set('n', '<leader>ds', function() widgets.preview(widgets.scopes).open() end, { buffer = 0, noremap = true, silent = true, desc = 'Toggle Scopes' })
      vim.keymap.set('n', '<leader>df', function() widgets.centered_float(widgets.frames).open() end, { buffer = 0, noremap = true, silent = true, desc = 'Show Frames' })
      vim.keymap.set('n', '<leader>dt', function() widgets.centered_float(widgets.threads).open() end, { buffer = 0, noremap = true, silent = true, desc = 'Show Threads' })
    end

  end
}

require('jdtls').start_or_attach(config)

