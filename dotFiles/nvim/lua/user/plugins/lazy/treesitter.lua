return
{
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = 'BufReadPost',
  opts = {
    sync_install = false,
    highlight = {
      -- `false` will disable the whole extension
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    ensure_installed = {
      "http",
      "java",
      -- "javascript",
      "json",
      "json5",
      -- "ledger",
      "lua",
      "markdown",
      "nix",
      -- "python",
      "rust",
    },
  },
  config = function (_, opts)
    require('nvim-treesitter.configs').setup(opts)
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevel = 2
    vim.opt.foldenable = false
  end,
}
