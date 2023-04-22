return {
  'nvim-telescope/telescope.nvim', version = '0.1.0',
  dependencies = {
    {'nvim-lua/plenary.nvim'},
    -- {'nvim-telescope/telescope-fzf-native.nvim'},
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
    local map = vim.keymap.set
    -- Telescope Mapping
    map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    map('n', '<leader>f.', function() builtin.find_files({hidden=true}) end, { desc = 'Find files including hidden' })
    map('n', '<leader>fl', function() builtin.find_files({follow=true}) end, { desc = 'Find files including symlinks' })
    -- map('n', '<leader>fc', function() builtin.find_files({cwd = '$HOME/.config/nvim/'}) end, { desc = 'Find configuration files' })
    map('n', '<leader>fc', function() builtin.find_files({cwd = '$HOME/.config/home-manager/dotFiles/nvim/'}) end, { desc = 'Find configuration files' })
    -- map('n', '<leader>fd', function()
      --   local dir = vim.fn.input("Enter directory path: ", "", "file")
      --   builtin.find_files({cwd = dir})
      -- end, {})
    map('n', '<leader>fd', function()
      vim.ui.input({prompt = 'Enter directory path: ', default = '', completion = 'file'}, function(dir)
        builtin.find_files({cwd = dir})
      end)
    end, { desc = 'Find files in custom directory'})
    map('n', '<leader>f/', function() builtin.find_files({cwd = vim.fs.dirname(vim.fn.expand('%'))}) end, { desc = 'Find files from current buffer directory'})
    map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
    map('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
    -- map('n', '<leader>ft', '<cmd>Telescope colorscheme<cr>', {})
    -- map('n', '<leader>ft', builtin.colorscheme, { desc = 'Color Schemes' })
    map('n', '<leader>hd', builtin.diagnostics, { desc = 'List Diagnostics' })
    map('n', '<leader>hh', builtin.help_tags, { desc = 'Help Tags' })
    map('n', '<leader>ht', builtin.colorscheme, { desc = 'Color Schemes' })
  end
}
