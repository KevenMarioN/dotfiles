-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("i", "jj", "<Esc>", opts)
map("i", "jk", "<Esc>", opts)

-- -- Increment/Decrement
-- map("n", "+", "<C-a>")
-- map("n", "-", "<C-x>")
--
-- -- Delete a word backwards
-- map("n", "dw", "vb_d")
--
-- -- New Tab
-- map("n", "te", "tabedit", opts)
-- map("n", "<tab>", ":tabnext<Return>", opts)
-- map("n", "<s-tab>", ":tabprev<Return>", opts)
