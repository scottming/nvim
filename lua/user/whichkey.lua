local M = {
	"folke/which-key.nvim",
	commit = "5224c261825263f46f6771f1b644cae33cd06995",
	event = "VeryLazy",
	dependencies = {
		{
			"ThePrimeagen/harpoon",
			commit = "f7040fd0c44e7a4010369136547de5604b9c22a1",
			dependencies = "nvim-lua/plenary.nvim",
			event = "VeryLazy",
		},
	},
}

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
-- see https://neovim.io/doc/user/map.html#:map-cmd
local vmappings = {
	["/"] = { "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Comment" },
	l = {
		name = "lsp",
		f = { "<cmd>lua vim.lsp.buf.format()<CR><ESC>", "format" },
	},
}

local mappings = {
	["a"] = { "<cmd>Lspsaga outline<cr>", "Symbols Outline" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["w"] = { "<cmd>w!<CR>", "Save" },
	["q"] = { "<cmd>q!<CR>", "Quit" },
	["/"] = { "<cmd>lua require('Comment.api').toggle.linewise()<CR>", "Comment" },
	["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	["f"] = {
		"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		"Find files",
	},
	["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
	["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },

	b = {
		name = "Buffers",
		j = { "<cmd>BufferLinePick<cr>", "Jump" },
		f = { "<cmd>Telescope buffers<cr>", "Find" },
		b = { "<cmd>b#<cr>", "Previous" },
		w = { "<cmd>BufferWipeout<cr>", "Wipeout" },
		e = {
			"<cmd>%bd|e#|bd#<cr>",
			"Close all but current",
		},
		p = {
			"<cmd>BufferLinePick<cr>",
			"Pick the buffer",
		},
		D = {
			"<cmd>BufferOrderByDirectory<cr>",
			"Sort by directory",
		},
	},

	g = {
		name = "Git",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Diff",
		},
	},

	h = {
		name = "Harpoon",
		h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle Harpoon" },
		a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add File" },
		f = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Next" },
		b = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Prev" },
		o = { "<cmd>nohlsearch<CR>", "No Highlight" },
		["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "File 1" },
		["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "File 2" },
		["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "File 3" },
	},

	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		d = { "<cmd>TroubleToggle<cr>", "Document Diagnostics" },
		f = { "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		j = {
			"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		w = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
	},
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
	},

	p = {
		name = "Project",
		f = { "<cmd>Telescope git_files<cr>", "Find File in project" },
		r = { "<cmd>Telescope oldfiles <cr>", "  Recently used files" },
		c = { ":e ~/.config/nvim/init.lua <CR>", "  Configuration" },
	},

	u = {
		name = "TestFile",
		t = { "<cmd>TestNearest<cr>", "Test Nearest" },
		T = { "<cmd>TestFile<cr>", "Test File" },
		l = { "<cmd>TestLast<cr>", "Run the last test" },
		g = { "<cmd>TestVisit<cr>", "Visit the last test" },
	},
	t = {
		name = "Neotest",
		t = { "<cmd>lua require('neotest').run.run()<cr>", "Test under cursor" },
		T = {
			'<cmd>lua require("neotest").run.run({vim.fn.expand("%")})<cr>',
			"Test File",
		},
		w = { '<cmd>lua require("neotest").watch.toggle()<cr>', "Toggle neotest watch" },
		W = { '<cmd>lua require("neotest").watch.toggle({vim.fn.expand("%")})<cr>', "Toggle neotest file watch" },
		l = { '<cmd>lua require("neotest").run.run_last()<cr>', "Run the last test" },
		o = { '<cmd>lua require("neotest").output.open({ enter = true })<cr>', "Show neotest output" },
		s = { '<cmd>lua require("neotest").summary.toggle()<cr>', "Toggle neotest summary" },
		c = {
			'<cmd>lua require("utils.telescope.neotest").strategies(require("telescope.themes").get_dropdown({}))<cr>',
			"Config the strategies",
		},
	},
	m = {
		name = "Terminal",
		f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
	},
	d = {
		name = "Debug",
		b = { '<cmd>lua require("dap").toggle_breakpoint()<cr>', "Toggle Breakpoint" },
		n = { '<cmd>lua require("dap").continue()<cr>', "Continue" },
		l = { '<cmd>lua require("dap").step_into()<cr>', "Step into" },
		j = { '<cmd>lua require("dap").step_over()<cr>', "Step Over" },
		r = { '<cmd>lua require("dap").repl.open()<cr>', "Open REPL" },
	},
}

function M.config()
	local which_key = require("which-key")
	which_key.setup(setup)
	which_key.register(mappings, opts)
	which_key.register(vmappings, vopts)
end

return M
