require("mason").setup()

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Show LSP definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "[d", function()
vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })                                                             -- jump to next diagnostic in buffer
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" }) -- show documentation for what is under cursor

local severity = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.enable({
  "lua_ls",
  "marksman",
  "gopls",
  "rust_analyzer",
})
