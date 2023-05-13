local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<cmd>lua require('utils').win_down()<CR>", opts)
keymap("n", "<C-k>", "<cmd>lua require('utils').win_up()<CR>", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
-- I use q when there is a lspsaga hover window
keymap("n", "q", "<Nop>", opts)

-- 10j 10k
keymap("n", "<C-d>", "10j", opts)
keymap("n", "<C-u>", "10k", opts)
keymap("n", "[g", '<cmd>lua require"gitsigns".prev_hunk()<cr>', opts)
keymap("n", "]g", '<cmd>lua require"gitsigns".next_hunk()<cr>', opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +5<CR>", opts)
keymap("n", "<C-Down>", ":resize -5<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<CR>", opts)
keymap("n", "_", "10<C-w><<CR>", opts)
keymap("n", "+", "10<C-w>><CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", opts)
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", opts)
keymap("n", "<leader>z", "<cmd>MaximizerToggle<CR>", opts)
keymap("n", "<A-\\>", "<cmd>ToggleTermSendCurrentLine<CR> j", opts)

vim.g.undotree_SetFocusWhenToggle = 1
keymap("n", "<F5>", "<cmd>UndotreeToggle<CR>", opts)

-- Move text up and down
-- keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
-- keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)
keymap("v", "*", "*``", opts)

-- Visual Block --
-- Move text up and down
--[[ keymap("x", "J", ":move '>+1<CR>gv-gv", opts) ]]
--[[ keymap("x", "K", ":move '<-2<CR>gv-gv", opts) ]]
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
keymap("t", "<C-Up>", "<ESC>:resize +5<CR>", term_opts)
keymap("t", "<C-Down>", "<ESC>:resize -5<CR>", term_opts)

-- cmdline
keymap("c", "<C-F>", "<Right>", opts)
keymap("c", "<C-B>", "<Left>", opts)
keymap("c", "<C-E>", "<End>", opts)
keymap("c", "<C-A>", "<Home>", opts)
keymap("c", "<A-Right>", "<S-Right>", opts)
keymap("c", "<A-Left>", "<S-Left>", opts)

-- for neovide
keymap("i", "<D-v>", "<C-r>+", opts)
keymap("n", "<D-v>", '"+p', opts)
keymap("c", "<D-v>", "<C-r>+", opts)

keymap("s", "<C-g>", "<ESC>", opts)
