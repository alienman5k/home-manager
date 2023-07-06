local ok, cmp = pcall(require, "cmp")
if not ok or cmp == nil then
  return
end

local M = {}

M.cmp_setup = function()
  local luasnip_loaded, luasnip = pcall(require, 'luasnip')
  cmp.setup({
    snippet = {
      -- required - you must specify a snippet engine
      expand = function(args)
        if luasnip_loaded then
          luasnip.lsp_expand(args.body) -- for `luasnip` users.
        end
      end,
    },
    formatting = {
      format = require("lspkind").cmp_format {
        with_text = true,
        menu = {
          nvim_lsp = "[lsp]",
          nvim_lua = "[api]",
          buffer = "[buf]",
          path = "[path]",
          luasnip = "[snip]",
          -- gh_issues = "[issues]",
          -- tn = "[tabnine]",
        },
      },
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept currently selected item. set `select` to `false` to only confirm explicitly selected items.
      ["<C-n>"] = {
        c = function(fallback)
          local _cmp = require("cmp")
          if _cmp and _cmp.visible() then
            _cmp.select_next_item()
          else
            fallback()
          end
        end,
      },
      ["<C-p>"] = {
        c = function(fallback)
          local _cmp = require("cmp")
          if _cmp and _cmp.visible() then
            _cmp.select_prev_item()
          else
            fallback()
          end
        end,
      },
      ["<C-l>"] = cmp.mapping {
        i = function (fallback)
          if luasnip_loaded and luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end
      },
    }),
    sources = cmp.config.sources({
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = 'nvim_lsp_signature_help' },
      { name = "luasnip" },
      { name = "buffer", keyword_length = 3 },
      { name = "path" },
    }),
    window = {
      -- completion = {
      --   border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
      -- },
      documentation = {
        border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
      },
    },
  })
end


return M
