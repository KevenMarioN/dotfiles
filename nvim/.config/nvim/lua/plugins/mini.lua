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

-- --- mini cmdline completion ---
require('mini.cmdline').setup({
  -- Mapeamentos essenciais para garantir que apagar funcione
  mappings = {
    complete_next = '<C-k>',
    complete_prev = '<C-j>',
    exec = '<CR>',
    cancel = '<Esc>', -- Às vezes o Esc estava bloqueando o Backspace
  },
  -- autocorrect = { enable = false },
  -- Certifique-se de que o foco está sendo liberado corretamente
  window = {
    position = 'bottom',
    zindex = 1000,
  },
 autocomplete = { enable = true, delay = 350 },
})


--- mini picker ---
local MiniExtra = require("mini.extra")
MiniExtra.setup()
-- keymaps
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

local statusline = require("mini.statusline")
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
