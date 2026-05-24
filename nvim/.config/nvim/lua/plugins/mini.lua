-- local MiniFiles = require("mini.files")
-- MiniFiles.setup({
--     mappings = {
--         go_in = "<CR>",
--         go_in_plus = "L",
--         go_out = "_",
--         go_out_plus = "H",
--     },
-- })
--
-- vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
-- vim.keymap.set("n", "<leader>-", function()
--     local buf_name = vim.api.nvim_buf_get_name(0)
--     -- Verifica se o buffer tem um nome e é um arquivo real
--     local path = (buf_name ~= "" and vim.fn.filereadable(buf_name) == 1) and buf_name or nil
--     MiniFiles.open(path)
--     -- Se você quiser focar no arquivo atual, use:
--     if path then MiniFiles.reveal_cwd() end
-- end, { desc = "Toggle into currently opened file" })

---- mini notify ----
require("mini.notify").setup({
  -- only show messages
  content = {
    format = function(notif)
      return notif.msg
    end,
  },
})

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--- mini cmdline completion ---
require("mini.cmdline").setup({
  autocorrect = { enable = false }
})


--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup({
  mappings = {
    move_down  = '<C-j>',
    move_start = '<C-h>',
    move_up    = '<C-k>'
  },
})

MiniExtra.setup()

-- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
  { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>xh", function() MiniExtra.pickers.hipatterns() end, { desc = "Mini Picker Hipatterns" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

--- mini completions ---
require("mini.completion").setup({
  lsp_completion = {
    auto_setup = true,
  },
})


--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
  snippets = {
    MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
  },
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff and fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
  source = MiniDiff.gen_source.git({ index = false }),
})

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })

require('mini.hipatterns').setup({
  highlighters = {
    fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    hack  = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    todo  = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    note  = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
  }
})

statusline = require("mini.statusline")
statusline.setup({
  content = {
    active = function()
      -- 1. Obtém dados de cada seção com larguras de truncagem padrão
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 40 })
      local diff = statusline.section_diff({ trunc_width = 75 })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
      local lsp = statusline.section_lsp({ trunc_width = 75 })
      local filename = statusline.section_filename({ trunc_width = 140 })
      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local location = statusline.section_location({ trunc_width = 75 })
      local search = statusline.section_searchcount({ trunc_width = 75 })

      -- 2. Combina os grupos em uma estrutura linear
      return statusline.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = mode_hl .. '1' ,                 strings = {'|>' } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<', -- Marca o ponto onde o statusline começa a ser truncado se a janela for pequena
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- Alinhamento à direita (tudo depois daqui vai para o canto direito)
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end,
  },
})

require('mini.comment').setup()
require('mini.animate').setup()
require('mini.starter').setup()
require('mini.pairs').setup()
require('mini.indentscope').setup()
require('mini.move').setup()
require('mini.cursorword').setup()
require('mini.ai').setup()
require('mini.bufremove').setup()
require('mini.trailspace').setup()
