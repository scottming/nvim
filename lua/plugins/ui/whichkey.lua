local M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"ThePrimeagen/harpoon",
			dependencies = "nvim-lua/plenary.nvim",
			event = "VeryLazy",
		},
	},
}

-- plugin UI
local setup = {
	plugins = {
		marks = true,
		registers = false,
		spelling = { enabled = true, suggestions = 20 },
		presets = {
			operators = false,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	icons = { breadcrumb = "»", separator = "➜", group = "+" },
	popup_mappings = { scroll_down = "<c-d>", scroll_up = "<c-u>" },
	window = {
		border = "rounded",
		position = "bottom",
		margin = { 1, 0, 1, 0 },
		padding = { 2, 2, 2, 2 },
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 },
		width = { min = 20, max = 50 },
		spacing = 3,
		align = "left",
	},
	ignore_missing = true,
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
	show_help = true,
	triggers = "auto",
	triggers_blacklist = { i = { "j", "k" }, v = { "j", "k" } },
}

local register_opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
}

local visual_opts = vim.tbl_extend("force", {}, register_opts, { mode = "v" })

-- leader groups (data)
local global = {
	["a"] = { "<cmd>Lspsaga outline<cr>", "Symbols Outline" },
	["e"] = { "<cmd>Neotree toggle<cr>", "Explorer" },
	["w"] = { "<cmd>w!<CR>", "Save" },
	["q"] = { "<cmd>q!<CR>", "Quit" },
	["/"] = { "<cmd>lua require('Comment.api').toggle.linewise()<CR>", "Comment" },
	["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	["f"] = { '<cmd>lua require("utils.fzf").files()<CR>', "Find files" },
	["F"] = { "<cmd>FzfLua live_grep<cr>", "Find Text" },
	["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
}

local buffers = {
	name = "Buffers",
	j = { "<cmd>BufferLinePick<cr>", "Jump" },
	f = { "<cmd>Telescope buffers<cr>", "Find" },
	b = { "<cmd>b#<cr>", "Previous" },
	w = { "<cmd>BufferWipeout<cr>", "Wipeout" },
	e = { "<cmd>%bd|e#|bd#<cr>", "Close all but current" },
	p = { "<cmd>BufferLinePick<cr>", "Pick the buffer" },
	D = { "<cmd>BufferOrderByDirectory<cr>", "Sort by directory" },
}

local git = {
	name = "Git",
	g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
	j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
	k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
	l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
	p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
	r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
	R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
	s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
	u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
	o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
	b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
	c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
	d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
}

local harpoon = {
	name = "Harpoon",
	h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle Harpoon" },
	a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add File" },
	f = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Next" },
	b = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Prev" },
	o = { "<cmd>nohlsearch<CR>", "No Highlight" },
	["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "File 1" },
	["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "File 2" },
	["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "File 3" },
}

local lsp = {
	name = "LSP",
	a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
	d = { "<cmd>TroubleToggle<cr>", "Document Diagnostics" },
	f = { "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>", "Format" },
	i = { "<cmd>LspClients<cr>", "Info" },
	j = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
	k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
	l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
	q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
	s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
	w = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
}

local search = {
	name = "Search",
	b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
	c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
	h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
	M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
	r = { '<cmd>lua require("telescope.builtin").oldfiles({only_cwd=true})<cr>', "open Recent files" },
	R = { "<cmd>Telescope registers<cr>", "Registers" },
	k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
	C = { "<cmd>Telescope commands<cr>", "Commands" },
}

local project = {
	name = "Project",
	f = { "<cmd>Telescope git_files<cr>", "Find File in project" },
	r = { "<cmd>Telescope oldfiles <cr>", "  Recently used files" },
	c = { ":e ~/.config/nvim/init.lua <CR>", "  Configuration" },
}

local vim_test = {
	name = "TestFile",
	t = { "<cmd>TestNearest<cr>", "Test Nearest" },
	T = { "<cmd>TestFile<cr>", "Test File" },
	l = { "<cmd>TestLast<cr>", "Run the last test" },
	g = { "<cmd>TestVisit<cr>", "Visit the last test" },
}

local neotest = {
	name = "Neotest",
	t = { "<cmd>lua require('neotest').run.run()<cr>", "Test under cursor" },
	T = { '<cmd>lua require("neotest").run.run({vim.fn.expand("%")})<cr>', "Test File" },
	w = { '<cmd>lua require("neotest").watch.toggle()<cr>', "Toggle neotest watch" },
	W = { '<cmd>lua require("neotest").watch.toggle({vim.fn.expand("%")})<cr>', "Toggle neotest file watch" },
	l = { '<cmd>lua require("neotest").run.run_last()<cr>', "Run the last test" },
	o = { '<cmd>lua require("neotest").output.open({ enter = true })<cr>', "Show neotest output" },
	s = { '<cmd>lua require("neotest").summary.toggle()<cr>', "Toggle neotest summary" },
	c = {
		'<cmd>lua require("utils.telescope.neotest").strategies(require("telescope.themes").get_dropdown({}))<cr>',
		"Config the strategies",
	},
}

local terminal = {
	name = "Terminal",
	f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
	h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
	v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
}

local mappings = vim.tbl_extend("force", global, {
	b = buffers,
	g = git,
	h = harpoon,
	l = lsp,
	s = search,
	p = project,
	u = vim_test,
	t = neotest,
	m = terminal,
})

local vmappings = {
	["/"] = { "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Comment" },
	l = {
		name = "lsp",
		f = { "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<CR><ESC>", "format" },
	},
}

function M.config()
	local which_key = require("which-key")
	which_key.setup(setup)
	which_key.register(mappings, register_opts)
	which_key.register(vmappings, visual_opts)
end

return M
