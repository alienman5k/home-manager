return {
  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Previous Hunk' })
      vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Next Hunk' })
      vim.keymap.set('n', '<localleader>gp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review hunk' })
      vim.keymap.set('n', '<localleader>gb', require('gitsigns').stage_buffer, { buffer = bufnr, desc = 'Stage [b]uffer' })
      vim.keymap.set('n', '<localleader>gs', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[S]tage hunk' })
      vim.keymap.set('n', '<localleader>gu', require('gitsigns').undo_stage_hunk, { buffer = bufnr, desc = '[U]ndo stage hunk' })
    end,
  },
}
