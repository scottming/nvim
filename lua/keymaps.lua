local map = vim.keymap.set

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function bind(mode, bindings, options)
	for _, binding in ipairs(bindings) do
		map(mode, binding[1], binding[2], options)
	end
end

-- normal
bind("n", {
	{ "<C-h>", "<C-w>h" },
	{ "<C-j>", "<cmd>lua require('utils').win_down()<CR>" },
	{ "<C-k>", "<cmd>lua require('utils').win_up()<CR>" },
	{ "<C-l>", "<C-w>l" },
	{ "q", "<Nop>" },
	{ "<C-d>", "10j" },
	{ "<C-u>", "10k" },
	{ "[g", '<cmd>lua require"gitsigns".prev_hunk()<cr>' },
	{ "]g", '<cmd>lua require"gitsigns".next_hunk()<cr>' },
	{ "<C-Up>", ":resize +5<CR>" },
	{ "<C-Down>", ":resize -5<CR>" },
	{ "<C-Left>", ":vertical resize -5<CR>" },
	{ "<C-Right>", ":vertical resize +5<CR>" },
	{ "_", "10<C-w><<CR>" },
	{ "=", "10<C-w>><CR>" },
	{ "<S-l>", "<cmd>BufferLineCycleNext<CR>" },
	{ "<S-h>", "<cmd>BufferLineCyclePrev<CR>" },
	{ "<leader>z", "<cmd>MaximizerToggle<CR>" },
	{ "<A-\\>", "<cmd>ToggleTermSendCurrentLine<CR> j" },
	{ "<F5>", "<cmd>UndotreeToggle<CR>" },
	{ "<D-v>", '"+p' },
}, opts)

vim.g.undotree_SetFocusWhenToggle = 1

-- insert
bind("i", {
	{ "jk", "<ESC>" },
	{ "kj", "<ESC>" },
	{ "<D-v>", "<C-r>+" },
}, opts)

-- visual
bind("v", {
	{ "<", "<gv" },
	{ ">", ">gv" },
	{ "<A-j>", ":m .+1<CR>==" },
	{ "<A-k>", ":m .-2<CR>==" },
	{ "p", '"_dP' },
	{ "*", "*``" },
}, opts)

-- visual block
bind("x", {
	{ "<A-j>", ":move '>+1<CR>gv-gv" },
	{ "<A-k>", ":move '<-2<CR>gv-gv" },
}, opts)

-- terminal
bind("t", {
	{ "<C-Up>", "<ESC>:resize +5<CR>" },
	{ "<C-Down>", "<ESC>:resize -5<CR>" },
}, term_opts)

-- cmdline
bind("c", {
	{ "<C-F>", "<Right>" },
	{ "<C-B>", "<Left>" },
	{ "<C-E>", "<End>" },
	{ "<C-A>", "<Home>" },
	{ "<A-Right>", "<S-Right>" },
	{ "<A-Left>", "<S-Left>" },
	{ "<D-v>", "<C-r>+" },
}, opts)

-- select mode
bind("s", {
	{ "<C-g>", "<ESC>" },
	{ "p", "p" },
}, opts)
