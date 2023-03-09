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
	{
		"rafcamlet/nvim-luapad",
		event = "VeryLazy",
		config = function()
			require("luapad").setup({
				count_limit = 150000,
				error_indicator = false,
				eval_on_move = true,
				error_highlight = "WarningMsg",
				split_orientation = "vertical",
				on_init = function()
					print("Hello from Luapad!")
				end,
				context = {
					the_answer = 42,
					shout = function(str)
						return (string.upper(str) .. "!")
					end,
				},
			})
		end,
	},

  -- navigating between main file and other file
	{
		"ThePrimeagen/harpoon",
		commit = "f7040fd0c44e7a4010369136547de5604b9c22a1",
		dependencies = "nvim-lua/plenary.nvim",
		event = "VeryLazy",
	},
	-- LSP
	{ "neovim/nvim-lspconfig", commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda", event = "VeryLazy" },
	{ "williamboman/mason.nvim", commit = "bfc5997e52fe9e20642704da050c415ea1d4775f", event = "VeryLazy" },
	{ "williamboman/mason-lspconfig.nvim", commit = "0eb7cfefbd3a87308c1875c05c3f3abac22d367c", event = "VeryLazy" },
	--[[ { "glepnir/lspsaga.nvim",  event = "VeryLazy" }, ]]
	{ dir = "~/Code/lspsaga.nvim", event = "VeryLazy" },
	{ dir = "~/Code/lspsaga-mini.nvim", event = "VeryLazy" },
	{ "tamago324/nlsp-settings.nvim", commit = "7be82f345f82f304ae817e3910d001aa96be01b1", event = "VeryLazy" }, -- language server settings defined in json for
	{ "jose-elias-alvarez/null-ls.nvim", commit = "456cd2754c56c991c5e4df60a807d054c1bc7148", event = "VeryLazy" }, -- for formatters and linters

	-- Debug
	{ "mfussenegger/nvim-dap", commit = "c1bfcd89ef440a44d02ade7e71befb1e5aa358ca", event = "VeryLazy" },
	{ "mfussenegger/nvim-dap-python", commit = "65ccab83fb3d0b29ead6c765c1c52a1ed49592e8", event = "VeryLazy" },
	{ "jbyuki/one-small-step-for-vimkind", commit = "aef1bdbb8347e6daaf33d5109002f3df243ebfe9", event = "VeryLazy" },

	-- Treesitter
	{ "nvim-treesitter/playground", event = "VeryLazy" },
	{
		"nvim-treesitter/nvim-treesitter",
		commit = "addc129a4f272aba0834bd0a7b6bd4ad5d8c801b",
		run = ":TSUpdate",
		event = "VeryLazy",
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy" },

	-- symbols
	{
		"scottming/symbols-outline.nvim",
		--[[ commit = "e459f3262c4c79a62e654ada0fbbb9758313c968", ]]
		branch = "support-elixir-private-functions",
		config = function()
			require("symbols-outline").setup()
		end,
		event = { "BufReadPost", "BufNewFile" },
	},

	-- Test

	{
		"nvim-neotest/neotest",
		version = "v2.8.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			-- Adpters
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-plenary",
			--[[ "rouge8/neotest-rust", ]]
			--[[ "haydenmeade/neotest-jest", ]]
		},
		event = "VeryLazy",
	},

	{ dir = "~/Code/neotest-elixir", event = "BufReadPre **/test/**/*_test.exs" },
	-- Folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
	},

	-- move faster
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
		event = "VeryLazy",
	},

	-- resize window when use
	--[[ { "beauwilliams/focus.nvim", event = "VeryLazy" }, ]]
	{ "beauwilliams/focus.nvim", commit = "3d9df42aa4f9b572348418207b752f81adea09a5" },

	-- vimscript plugins
	{ "vim-test/vim-test", event = "VeryLazy" },
	"tpope/vim-abolish",
	-- for highlight the pattern: search and so on
	"markonm/traces.vim",
	"tpope/vim-surround",
	-- bdelete, <leader>c
	"moll/vim-bbye",
	"tpope/vim-projectionist",
	-- maximize the window by <leader>z
	"szw/vim-maximizer",
	-- Switch between single-line and multiline forms of code
	{ "AndrewRadev/splitjoin.vim", commit = "e6af44293c55431d78cc2ddd4335ed68e6fcf6ed" },

	{ "nvim-tree/nvim-web-devicons", commit = "c3c1dc4e36969370ff589b7025df8ec2e5c881a2" },
	{ "nvim-tree/nvim-tree.lua", commit = "bbb6d4891009de7dab05ad8fc2d39f272d7a751c" },

	-- Basic plugins
	---------------------
	-- Autopairs, integrates with both cmp and treesitter
	{ "windwp/nvim-autopairs", commit = "ab49517cfd1765b3f3de52c1f0fda6190b44e27b", event = "VeryLazy" },
	-- Easily comment stuff
	{ "numToStr/Comment.nvim", event = "VeryLazy" },
	-- improve startup time
	--[[ "lewis6991/impatient.nvim", ]]
	-- bufferline, lualine
	{ "akinsho/bufferline.nvim", version = "v3.1.0", event = "VeryLazy" },
	{ "nvim-lualine/lualine.nvim", commit = "e99d733e0213ceb8f548ae6551b04ae32e590c80", event = "VeryLazy" }, -- status line plugin
	{ "akinsho/toggleterm.nvim", version = "v2.2.1", event = "VeryLazy" },
	-- project manager
	"ahmedkhalf/project.nvim",
	"goolord/alpha-nvim",
	{ "lukas-reineke/indent-blankline.nvim", event = { "BufReadPost", "BufNewFile" } },
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
	{ "hrsh7th/nvim-cmp", commit = "feed47fd1da7a1bad2c7dca456ea19c8a5a9823a", event = "InsertEnter" }, -- The completion plugin
	{ "hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa", event = "InsertEnter" }, -- buffer completions
	{ "hrsh7th/cmp-path", commit = "91ff86cd9c29299a64f968ebb45846c485725f23", event = "InsertEnter" }, -- path completions
	{ "hrsh7th/cmp-cmdline", commit = "8fcc934a52af96120fe26358985c10c035984b53", event = "InsertEnter" }, -- cmdline completions
	-- snippet completions
	{ "saadparwaiz1/cmp_luasnip", commit = "18095520391186d634a0045dacaa346291096566", event = "InsertEnter" },
	{ "hrsh7th/cmp-nvim-lsp", commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef", event = "InsertEnter" },
	-- copilot
	"github/copilot.vim",

	-- snippets
	{ "L3MON4D3/LuaSnip", commit = "9b5be5e9b460fad7134991d3fd0434466959db08", event = "InsertEnter" },
	{ "rafamadriz/friendly-snippets", commit = "009887b76f15d16f69ae1341f86a7862f61cf2a1", event = "InsertEnter" }, -- a bunch of snippets to use

	-- Telescope
	{ "nvim-telescope/telescope.nvim", commit = "a3f17d3baf70df58b9d3544ea30abe52a7a832c2" },

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		commit = "3b6c0a6412b31b91eb26bb8f712562cf7bb1d3be",
		event = { "BufReadPost", "BufNewFile" },
	},
})
