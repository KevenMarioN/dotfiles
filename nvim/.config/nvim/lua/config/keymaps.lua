-- ====================================================================================================================
-- TITLE: Neovim Keymaps
-- ABOUT: Sets some quality-of-life keymaps
-- ====================================================================================================================

local key = vim.keymap

-- Center screen when jumping
key.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
key.set('n', 'N', 'Nzzzv', { desc = 'Previus search result (centered)' })
key.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
key.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Buffer navigation
key.set('n', '<leader>bn', '<Cmd>bnext<CR>', { desc = 'Next buffer'})
key.set('n', '<leader>bp', '<Cmd>bprevious<CR>', { desc = 'Previous buffer'})

-- Better window navigation
key.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
key.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
key.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
key.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Splitting & Resizing
key.set('n', '<leader>sv', '<Cmd>vsplit<CR>', { desc = 'Split window vertically' })
key.set('n', '<leader>sh', '<Cmd>split<CR>', { desc = 'Split window horizontally' })
key.set('n', '<C-Up>', '<Cmd>resize +2<CR>', { desc = 'Increase window height' })
key.set('n', '<C-Down>', '<Cmd>resize -2<CR>', { desc = 'Increase window height' })
key.set('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
key.set('n', '<C-Right>','<Cmd>horizontal resize +2<CR>', { desc = 'Increase window width' })

-- Better indenting in visual mode
key.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
key.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Better J behavior
key.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })

-- Quick config editing
key.set('n', '<leader>rc', '<Cmd>e ~/.config/nvim/init.lua<CR>', { desc = 'Edit config' })

-- File Explorer
key.set('n', '<leader>m', '<Cmd>NvimTreeFocus<CR>', { desc = 'Focus on File' })
key.set('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', { desc = 'Toogle File' })
