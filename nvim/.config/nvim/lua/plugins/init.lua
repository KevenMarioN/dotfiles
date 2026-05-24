vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-tree/nvim-tree.lua",
  { src = "https://github.com/ibhagwan/fzf-lua",                branch = "main" },
})


require("nvim-web-devicons").setup()
require("plugins/mini")
require("plugins/treesitter")
require("plugins/nvim-tree")
