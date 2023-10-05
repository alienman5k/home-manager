local M = {}

local function lspconfig_setup()
  -- print('Start lspconfig_setup')
  local _loaded, lspconfig = pcall(require, 'lspconfig')
  if _loaded then
    lspconfig.jdtls.setup({
      cmd = { 'jdt-language-server' }
    })
  end
end

local function add_jdtls_keymaps(bufnr)
  local jdtls = require('jdtls')
  vim.keymap.set('n', '<localleader>o', jdtls.organize_imports, { buffer = bufnr, desc = 'Organize Imports' })
  vim.keymap.set('n', '<localleader>u', jdtls.update_project_config, { buffer = bufnr, desc = 'Update project config' })
  vim.keymap.set('n', '<localleader>cc', function() jdtls.compile('incremental') end, { buffer = bufnr, desc = 'Compile Incremental' })
  vim.keymap.set('n', '<localleader>cc', function() jdtls.compile('full') end, { buffer = bufnr, desc = 'Compile Full' })
  vim.keymap.set('n', '<localleader>cb', jdtls.build_projects, { buffer = bufnr, desc = 'Build Projects' })
  vim.keymap.set('n', '<localleader>tc', jdtls.test_class, { buffer = bufnr, desc = 'Test class' })
  vim.keymap.set('n', '<localleader>tt', jdtls.test_nearest_method, { buffer = bufnr, desc = 'Test nearest method' })
  vim.keymap.set('n', '<localleader>tp', jdtls.pick_test, { buffer = bufnr, desc = 'Pick test to run' })
  vim.keymap.set('n', '<localleader>tg', require('jdtls.tests').generate, { buffer = bufnr, desc = 'Generate tests' })
  vim.keymap.set('n', '<localleader>ts', require('jdtls.tests').goto_subjects, { buffer = bufnr, desc = 'Go to subjects' })
  local wc_loaded, wc = pcall(require, 'which-key')
  if wc_loaded then
    wc.register({
      ['<localleader>c'] = { name = '+Code' },
      ['<localleader>t'] = { name = '+Test' }
    }, {buffer = bufnr})
  end
end

local function jdtls_setup()
  -- print('Start jdtls_setup')
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local home = os.getenv('HOME')
  -- print('home: ', home)
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
    vim.fn.glob(home .. '/.nix-profile/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar', 1)
  }
  -- vscode-java-test bundle
  vim.list_extend(bundles, vim.split(vim.fn.glob(home .. '/.nix-profile/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar', 1), '\n'))

  local java_jdk_dir = '/Library/Java/JavaVirtualMachines/'
  -- Configuration to pass to the LSP Client when a Java file is open
  local config = {
    cmd = {
      home .. '/.nix-profile/bin/jdt-language-server',
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
              name = 'JavaSE-1.8',
              path = vim.fn.glob(java_jdk_dir .. 'jdk1.8.*.jdk/Contents/Home/')
            },
            {
              name = 'JavaSE-11',
              path = vim.fn.glob(java_jdk_dir .. 'jdk-11.*.jdk/Contents/Home/')
            },
            {
              name = 'JavaSE-17',
              path = vim.fn.glob(java_jdk_dir .. 'jdk-17.*.jdk/Contents/Home/')
            },
          }
        },
        format = {
          enabled = true,
          settings = {
            url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml'
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
  vim.cmd('edit')
end

vim.api.nvim_create_user_command('JdtInit', M.init, { desc = 'Initialize jdtls', nargs = 0,})

return M
