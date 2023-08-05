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

local function add_jdtls_keymaps(bufnr)
  local jdtls = require('jdtls')
  vim.keymap.set('n', '<localleader>co', jdtls.organize_imports, { buffer = bufnr, desc = '[O]rganize Imports' })
  vim.keymap.set('n', '<localleader>cu', jdtls.update_project_config, { buffer = bufnr })
  vim.keymap.set('n', '<localleader>cc', function() jdtls.compile('incremental') end, { buffer = bufnr, desc = '[C]ompile Incremental' })
  vim.keymap.set('n', '<localleader>cc', function() jdtls.compile('full') end, { buffer = bufnr, desc = 'Compile [F]ull' })
  vim.keymap.set('n', '<localleader>cb', jdtls.build_projects, { buffer = bufnr, desc = '[B]uild' })
  vim.keymap.set('n', '<localleader>tc', jdtls.test_class, { buffer = bufnr, desc = 'Test [c]lass' })
  vim.keymap.set('n', '<localleader>tt', jdtls.test_nearest_method, { buffer = bufnr, desc = '[T]est nearest method' })
  vim.keymap.set('n', '<localleader>tp', jdtls.pick_test, { buffer = bufnr, desc = '[P]ick test to run' })
  vim.keymap.set('n', '<localleader>tg', require('jdtls.tests').generate, { buffer = bufnr, desc = '[G]enerate tests' })
  vim.keymap.set('n', '<localleader>ts', require('jdtls.tests').goto_subjects, { buffer = bufnr, desc = 'Go to [s]ubjects' })
  local wc_loaded, wc = pcall(require, 'which-key')
  if wc_loaded then
    wc.register({
      ["<localleader>c"] = { name = "+Code" },
      ["<localleader>t"] = { name = "+Test" }
    }, {buffer = bufnr})
  end
end

local function jdtls_setup()
  -- print("Start jdtls_setup")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local home = os.getenv('HOME')
  -- print('home: ', home)
  local mason_home = home .. '/.local/share/nvim/mason'
  -- print('mason home: ', mason_home)
  local jdtls_install_dir = mason_home .. '/share/jdtls/'
  local jdtls_config_dir = mason_home .. '/share/jdtls/config/'
  local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

  -- Define the capabilities for the LSP Client
  local okcmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  local cmp_capabilities = vim.lsp.protocol.make_client_capabilities()
  if okcmp then
    cmp_capabilities = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
  end
  -- Define the bundles for JSTL
  local bundles = {
    --  java-debug bundle
    vim.fn.glob(mason_home .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1)
  }
  -- vscode-java-test bundle
  vim.list_extend(bundles, vim.split(vim.fn.glob(mason_home .. '/packages/java-test/extension/server/*.jar', 1), '\n'))

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
    on_attach = function(_, bufnr)
      add_jdtls_keymaps(bufnr)
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
      require('jdtls.setup').add_commands()
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
