-- Additional Neovim syntax highlithing and support
return {
  -- Ledger files
  {
    'ledger/vim-ledger',
    enabled = true,
    ft = { 'dat', 'ledger' }
  },
  -- NeOrg
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    enabled = false,
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              work = "~/DevProjects/notes/work",
              personal = "~/DevProjects/notes/personal",
            },
          },
        },
      },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },

  {
    'LnL7/vim-nix',
    ft = 'nix',
  }
}
