require("vim._core.ui2").enable({})

require("config.options")
require("config.globals")
require("config.autocmds")
require("config.keymaps")
require("plugins.init")
require("lsp")

require("gruvbox").setup()

vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")
