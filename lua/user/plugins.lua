---@diagnostic disable: assign-type-mismatch
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

-- Install your plugins here
return require("lazy").setup({
	-- nvim dev
	"folke/neodev.nvim",
	-- LSP
	"neovim/nvim-lspconfig",
	--[[ { "glepnir/lspsaga.nvim", commit = "e5d5a3243616af78f0d7b7b29aa700a16e516a23" }) ]]
	"glepnir/lspsaga.nvim",
	"williamboman/nvim-lsp-installer", -- simple to use language server installer
	"tamago324/nlsp-settings.nvim", -- language server settings defined in json for
	"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters

	-- Debug
	"mfussenegger/nvim-dap",
	"mfussenegger/nvim-dap-python",
	"jbyuki/one-small-step-for-vimkind",

	-- Treesitter
	"nvim-treesitter/playground",
	{
		"nvim-treesitter/nvim-treesitter",
		commit = "addc129a4f272aba0834bd0a7b6bd4ad5d8c801b",
		run = ":TSUpdate",
	},
	"JoosepAlviste/nvim-ts-context-commentstring",

	-- symbols
	{
		"scottming/symbols-outline.nvim",
		--[[ commit = "e459f3262c4c79a62e654ada0fbbb9758313c968", ]]
		branch = "support-elixir-private-functions",
		config = function()
			require("symbols-outline").setup()
		end,
	},

	-- Test
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-plenary",
			"rouge8/neotest-rust",
			"haydenmeade/neotest-jest",
		},
	},

	{ "jfpedroza/neotest-elixir", branch = "jp/iex_strategy" },

	-- Folding
	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },

	-- move faster
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},

	-- resize window when use
	"kwkarlwang/bufresize.nvim",

	-- vimscript plugins
	"vim-test/vim-test",
	"tpope/vim-surround",
	-- bdelete, <leader>c
	"moll/vim-bbye",
	"tpope/vim-projectionist",
	-- maximize the window by <leader>z
	"szw/vim-maximizer",

	"kyazdani42/nvim-web-devicons",
	"kyazdani42/nvim-tree.lua",

	-- Basic plugins
	---------------------
	-- Autopairs, integrates with both cmp and treesitter
	"windwp/nvim-autopairs",
	-- Easily comment stuff
	"numToStr/Comment.nvim",
	-- improve startup time
	"lewis6991/impatient.nvim",
	-- bufferline, lualine
	{ "akinsho/bufferline.nvim", version = "v3.1.0" },
	"nvim-lualine/lualine.nvim", -- status line plugin
	{ "akinsho/toggleterm.nvim", version = "v2.1.0" },
	-- project manager
	"ahmedkhalf/project.nvim",
	"goolord/alpha-nvim",
	"lukas-reineke/indent-blankline.nvim",
	-- This is needed to fix lsp doc highlight
	"antoinemadec/FixCursorHold.nvim",
	"folke/which-key.nvim",
	---------------------

	-- Colorschemes
	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	"lunarvim/darkplus.nvim",
	"projekt0n/github-nvim-theme",
	"navarasu/onedark.nvim",
	{ dir = "~/Code/dracula_pro" },

	-- cmp plugins
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"saadparwaiz1/cmp_luasnip", -- snippet completions
	"hrsh7th/cmp-nvim-lsp",
	{
		"tzachar/cmp-tabnine",
		config = function()
			local tabnine = require("cmp_tabnine.config")
			tabnine:setup({
				max_lines = 1000,
				max_num_results = 20,
				sort = true,
			})
		end,
	},

	-- snippets
	"L3MON4D3/LuaSnip", --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- Telescope
	"nvim-telescope/telescope.nvim",

	-- Git
	"lewis6991/gitsigns.nvim",
})
