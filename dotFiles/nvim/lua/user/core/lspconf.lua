local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

-- This options apply to any buffer after LSP plugin has loaded
local opts = { noremap = true, silent = true }
local map = vim.keymap.set
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gt", vim.lsp.buf.type_definition, opts)
map("n", "gi", vim.lsp.buf.implementation, opts )
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>cr", vim.lsp.buf.rename, opts)
map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, opts)
map("n", "<leader>ee", vim.diagnostic.open_float, opts)
map("n", "<leader>ej", vim.diagnostic.goto_next, opts)
map("n", "<leader>ek", vim.diagnostic.goto_prev, opts)
map("n", "<leader>el", "<cmd>Telescope diagnostics<cr>", opts)
map("i", "<C-c>", vim.lsp.buf.completion, opts)

-- WIP
local on_attach_lsp = function (client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts, { desc = 'Rename'} )
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts, { desc = 'Code Actions' })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Configuration applies only to Lua LSP
lspconfig.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {"vim"},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
    capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
  },
  on_attach = function()
    local bufmap = vim.keymap.set
    local bufopts = {buffer = 0}
    bufmap("n", "K", vim.lsp.buf.hover, bufopts)
    bufmap("n", "<leader>la", vim.lsp.buf.code_action, bufopts)
    bufmap("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
    bufmap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, bufopts)
  end
}
