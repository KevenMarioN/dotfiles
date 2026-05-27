return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  settings = {
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
    },
  },
}
