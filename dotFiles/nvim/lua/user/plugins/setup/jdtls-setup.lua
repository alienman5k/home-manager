local M = {}

local function lspconfig_setup()
  -- print("Start lspconfig_setup")
  local _loaded, lspconfig = pcall(require, "lspconfig")
  if _loaded then
    lspconfig.jdtls.setup({
      cmd = { 'jdtls' }
    })
  end
end

local function jdtls_setup()
  -- print("Start jdtls_setup")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local home = os.getenv('HOME')
  local jdtls_install_dir = home .. '/.local/share/nvim/mason/share/jdtls/'
  local jdtls_config_dir = home .. '/.local/share/nvim/mason/share/jdtls/config/'
  local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

  -- Define the capabilities for the LSP Client
  local okcmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  local cmp_capabilities = vim.lsp.protocol.make_client_capabilities()
  if okcmp then
    cmp_capabilities = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
  end
  -- Define the bundles for JSTL
  local bundles = {
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
  }
  vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar"), "\n"))

  local java_jdk_dir = "/Library/Java/JavaVirtualMachines/"
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
    root_dir = require('jdtls.setup').find_root({ '.git', 'pom.xml', 'build.xml', 'mvnw', 'gradlew' }),
    settings = {
      java = {
        configuration = {
          -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          -- And search for `interface RuntimeOption`
          -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
          runtimes = {
            {
              name = "JavaSE-1.8",
              path = vim.fn.glob(java_jdk_dir .. "jdk1.8.*.jdk/Contents/Home/")
            },
            {
              name = "JavaSE-11",
              path = vim.fn.glob(java_jdk_dir .. "jdk-11.*.jdk/Contents/Home/")
            },
            {
              name = "JavaSE-17",
              path = vim.fn.glob(java_jdk_dir .. "jdk-17.*.jdk/Contents/Home/")
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
    on_attach = function(client, bufnr)
      local jdtls = require('jdtls')
      vim.keymap.set('n', '<leader>co', jdtls.organize_imports, { buffer = bufnr, desc = 'Organize Imports' })
      vim.keymap.set('n', '<leader>cu', jdtls.update_project_config, { buffer = bufnr })
      vim.keymap.set('n', '<leader>cc', function() jdtls.compile('full') end, { buffer = bufnr, desc = 'Compile' })
      vim.keymap.set('n', '<leader>cb', jdtls.build_projects, { buffer = bufnr, desc = 'Build' })
      local okwc, wc = pcall(require, 'which-key')
      if okwc then
        wc.register({ '<leader>ct', name = 'Test' })
      end
      vim.keymap.set('n', '<leader>ctc', jdtls.test_class, { buffer = bufnr, desc = 'Test class' })
      vim.keymap.set('n', '<leader>ctt', jdtls.test_nearest_method, { buffer = bufnr, desc = 'Test nearest method' })
      -- vim.keymap.set('n', '<leader>tm', jdtls.test_nearest_method, { buffer = bufnr, desc = 'Test nearest method' })

      jdtls.setup_dap({ hotcodereplace = 'auto' })
      require('jdtls.setup').add_commands()

      -- local dap_loaded, dap = pcall(require, 'dap')
      -- if dap_loaded then
      --   vim.keymap.set('n', '<leader>db', require 'dap'.toggle_breakpoint, { buffer = bufnr, desc = 'Toggle Breakpoint' })
      --   vim.keymap.set('n', '<leader>dc', require 'dap'.continue, { buffer = bufnr, desc = 'Continue Debugger' })
      --   vim.keymap.set('n', '<leader>di', require 'dap'.step_into, { buffer = bufnr, desc = 'Step Into' })
      --   vim.keymap.set('n', '<leader>do', require 'dap'.step_over, { buffer = bufnr, desc = 'Step Over' })
      --   vim.keymap.set('n', '<F7>', require 'dap'.step_into, { buffer = bufnr, desc = 'Step Into' })
      --   vim.keymap.set('n', '<S-F7>', dap.step_back, { buffer = bufnr, desc = 'Step Back' })
      --   vim.keymap.set('n', '<F8>', require 'dap'.step_over, { buffer = bufnr, desc = 'Step Over' })
      --   vim.keymap.set('n', '<S-F8>', dap.step_out, { buffer = bufnr, desc = 'Step out' })
      --   vim.keymap.set('n', '<F9>', dap.continue, { buffer = bufnr, desc = 'Continue' })
      --   -- vim.keymap.set('n', '<leader>dc', require'dap'.continue, { buffer = bufnr, desc = 'Toggle Breakpoint' })
      -- end

      -- if client.name == "jdt.ls" then
      --   print("dap_setup for jdt.ls in jdtls-setup")
      --   require("jdtls").setup_dap { hotcodereplace = "auto" }
      --   require("jdtls.dap").setup_dap_main_class_configs()
      --   vim.lsp.codelens.refresh()
      -- end
    end
  }

  require('jdtls').start_or_attach(config)
end

function M.setup()
  local auto_start = Jdtl_auto_start
  if not auto_start then
    return
  end
  local _loaded, _ = pcall(require, 'jdtls')
  if _loaded then
    jdtls_setup()
  else
    lspconfig_setup()
  end
end

function M.init()
  Jdtl_auto_start = true
  -- To refresh the current buffer where JdtInitis called
  vim.cmd("edit")
end

vim.api.nvim_create_user_command("JdtInit", M.init, { desc = "Initialize jdtls", nargs = 0,})

return M
