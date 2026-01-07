vim.g.mapleader = " "

local keymap = vim.keymap.set

keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk"})

keymap("n", "<leader>nh>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Incrment/decrement numbers 2
keymap("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", "<CMD>close<CR>", {desc = "Close current split" })

-- Tabs
keymap("n", "<leader>to", "<CMD>tabnew<CR>", { desc = "Open new tab" })
keymap("n", "<leader>tx", "<CMD>tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>tn", "<CMD>tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>tp", "<CMD>tabp<CR>", { desc = "Go to previous tab" })
keymap("n", "<leader>tf", "<CMD>tabnew %<CR>", { desc = "Open current buffer in new tab" })
