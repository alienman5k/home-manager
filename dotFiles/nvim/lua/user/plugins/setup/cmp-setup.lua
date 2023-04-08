local ok, cmp = pcall(require, "cmp")
if not ok or cmp == nil then
  return
end

local M = {}

M.cmp_setup = function()
  cmp.setup({
    snippet = {
      -- required - you must specify a snippet engine
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- for `luasnip` users.
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
      ["<c-b>"] = cmp.mapping.scroll_docs(-4),
      ["<c-f>"] = cmp.mapping.scroll_docs(4),
      ["<c-space>"] = cmp.mapping.complete(),
      ["<c-e>"] = cmp.mapping.abort(),
      ["<cr>"] = cmp.mapping.confirm({ select = true }), -- accept currently selected item. set `select` to `false` to only confirm explicitly selected items.
      ["<c-n>"] = {
        c = function(fallback)
          local _cmp = require("cmp")
          if _cmp and _cmp.visible() then
            _cmp.select_next_item()
          else
            fallback()
          end
        end,
      },
      ["<c-p>"] = {
        c = function(fallback)
          local _cmp = require("cmp")
          if _cmp and _cmp.visible() then
            _cmp.select_prev_item()
          else
            fallback()
          end
        end,
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
  })
end


return M
