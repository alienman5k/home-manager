return {
  'nvim-telescope/telescope.nvim', version = '0.1.2',
  dependencies = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    {'nvim-tree/nvim-web-devicons'}, -- optional
  },
  opts = {
    pickers = {
      find_files = {
        follow = false,
      }
    }
  },
  -- cmd = "Telescope",
  -- keys = {
  --   { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  --   { "<leader>fc", nil, desc = "Find configuration files" },
  --   { '<leader>fp', nil, desc = 'Find files including symlinks' },
  --   { '<leader>ht', nil, desc = 'Color Schemes' },
  -- },
  config = function (_,opts)
    require('telescope').setup(opts)
    -- require('telescope').load_extension('fzf')
    local builtin = require 'telescope.builtin'
    -- Telescope Mapping
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>f.', function() builtin.find_files({hidden=true}) end, { desc = 'Find files including hidden' })
    vim.keymap.set('n', '<leader>fl', function() builtin.find_files({follow=true}) end, { desc = 'Find files including symlinks' })
    -- vim.keymap.set('n', '<leader>fc', function() builtin.find_files({cwd = '$HOME/.config/nvim/'}) end, { desc = 'Find configuration files' })
    vim.keymap.set('n', '<leader>fc', function() builtin.find_files({cwd = '$HOME/.config/home-manager/dotFiles/nvim/'}) end, { desc = 'Find configuration files' })
    -- vim.keymap.set('n', '<leader>fd', function()
      --   local dir = vim.fn.input("Enter directory path: ", "", "file")
      --   builtin.find_files({cwd = dir})
      -- end, {})
    vim.keymap.set('n', '<leader>fd', function()
      vim.ui.input({prompt = 'Enter directory path: ', default = '', completion = 'file'}, function(dir)
        builtin.find_files({cwd = dir})
      end)
    end, { desc = 'Find files in custom directory'})
    vim.keymap.set('n', '<leader>f/', function() builtin.find_files({cwd = vim.fs.dirname(vim.fn.expand('%'))}) end, { desc = 'Find files from current buffer directory'})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = 'List Buffers' })
    -- vim.keymap.set('n', '<leader>ft', '<cmd>Telescope colorscheme<cr>', {})
    -- vim.keymap.set('n', '<leader>ft', builtin.colorscheme, { desc = 'Color Schemes' })
    vim.keymap.set('n', '<leader>hd', builtin.diagnostics, { desc = 'List Diagnostics' })
    vim.keymap.set('n', '<leader>hh', builtin.help_tags, { desc = 'Help Tags' })
    vim.keymap.set('n', '<leader>ht', builtin.colorscheme, { desc = 'Color Schemes' })
  end
}
