local ok, nvtree = pcall(require, 'nvim-tree')
if not ok then
  return
end

nvtree.setup({
  sort_by = "case_sensitive",
  -- auto_close = true, -- No longer supported
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        -- { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
    -- custom = { "target" }
  },
})

vim.keymap.set('n', '<leader>tt', nvtree.toggle, {})
