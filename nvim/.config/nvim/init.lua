require("vim._core.ui2").enable({})

require("config.options")
require("config.globals")
require("config.autocmds")
require("plugins.init")
require("config.keymaps")
require("lsp")

require("gruvbox").setup()

vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")
