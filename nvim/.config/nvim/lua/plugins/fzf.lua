-- fzf lua
--
-- Garante que o fzf-lua esteja disponível antes de mapear
local ok, fzf = pcall(require, "fzf-lua")

if ok then
  fzf.setup({})

  -- fzf-lua keymaps
  vim.keymap.set('n', '<leader>ff', fzf.files, { desc = "FZF Files" })
  vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = "FZF Live Grep" })
  vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = "FZF Buffers" })
  vim.keymap.set("n", "<leader>fl", fzf.blines, { desc = "FZF Fuzzy in opened file " })
  vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = "FZF Help Tags" })
  vim.keymap.set('n', '<leader>fx', fzf.diagnostics_document, { desc = "FZF Diagnostics Document" })
  vim.keymap.set('n', '<leader>fX', fzf.diagnostics_workspace, { desc = "FZF Diagnostics Workspace" })
  vim.keymap.set('n', '<leader>fs', fzf.lsp_document_symbols, { desc = "FZF Document Symbols" })
  vim.keymap.set('n', '<leader>fw', fzf.lsp_workspace_symbols, { desc = "FZF Workspace Symbols" })
  vim.keymap.set('n', '<leader>fd', fzf.lsp_finder, { desc = "FZF LSP Finder" })
  vim.keymap.set('n', '<leader>fr', fzf.lsp_references,
    { desc = "FZF Show all references to the symbol under the cursor" })
  vim.keymap.set('n', '<leader>ft', fzf.lsp_typedefs,
    { desc = "FZF Jump to the type definition of symbol under the cursor" })
  vim.keymap.set('n', '<leader>fi', fzf.lsp_implementations, { desc = "FZF Go to implementation" })
else
  vim.notify("fzf-lua not found", vim.log.levels.WARN)
end
