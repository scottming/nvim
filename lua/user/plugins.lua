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

	{
		"goolord/alpha-nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		commit = "3847d6baf74da61e57a13e071d8ca185f104dc96",
	},
	-- navigating between main file and other file
	{
		"ThePrimeagen/harpoon",
		commit = "f7040fd0c44e7a4010369136547de5604b9c22a1",
		dependencies = "nvim-lua/plenary.nvim",
		event = "VeryLazy",
	},
	-- LSP
	{ "neovim/nvim-lspconfig", commit = "4bb0f1845c5cc6465aecedc773fc2d619fcd8faf", event = "VeryLazy" },
	{ "williamboman/mason.nvim", commit = "698cd0c4f10480991e665f31977650858d625af1", event = "VeryLazy" },
	{ "williamboman/mason-lspconfig.nvim", commit = "a81503f0019942111fe464209237f8b4e85f4687", event = "VeryLazy" },
	--[[ { "glepnir/lspsaga.nvim",  event = "VeryLazy" }, ]]
	{ dir = "~/Code/lspsaga.nvim", event = "LspAttach" },
	{ dir = "~/Code/lspsaga-mini.nvim", event = "LspAttach" },
	{ "tamago324/nlsp-settings.nvim", commit = "7be82f345f82f304ae817e3910d001aa96be01b1", event = "VeryLazy" }, -- language server settings defined in json for
	{ "jose-elias-alvarez/null-ls.nvim", commit = "456cd2754c56c991c5e4df60a807d054c1bc7148", event = "VeryLazy" }, -- for formatters and linters
	{
		"RRethy/vim-illuminate",
		commit = "d6ca7f77eeaf61b3e6ce9f0e5a978d606df44298",
		event = "VeryLazy",
	},

	-- Debug
	{ "mfussenegger/nvim-dap", commit = "c1bfcd89ef440a44d02ade7e71befb1e5aa358ca", event = "VeryLazy" },
	{ "mfussenegger/nvim-dap-python", commit = "65ccab83fb3d0b29ead6c765c1c52a1ed49592e8", event = "VeryLazy" },
	{ "jbyuki/one-small-step-for-vimkind", commit = "aef1bdbb8347e6daaf33d5109002f3df243ebfe9", event = "VeryLazy" },

	-- Treesitter
	--[[ { "nvim-treesitter/playground", event = "VeryLazy" }, ]]
	{ dir = "~/Code/playground", event = "VeryLazy" },
	{
		"nvim-treesitter/nvim-treesitter",
		commit = "6f5a4f6306e6dfd23f93c8b60493871c9a600cc0",
		run = ":TSUpdate",
		event = "VeryLazy",
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy" },

	-- symbols
	{
		"scottming/symbols-outline.nvim",
		--[[ commit = "e459f3262c4c79a62e654ada0fbbb9758313c968", ]]
		branch = "master",
		config = function()
			require("symbols-outline").setup()
		end,
		evetn = { "LspAttach" },
		--[[ event = { "BufReadPost", "BufNewFile" }, ]]
	},

	-- Test
	{ "rcarriga/nvim-notify", commit = "50d037041ada0895aeba4c0215cde6d11b7729c4" },
	{
		dir = "~/Code/neotest",
		--[[ "nvim-neotest/neotest", ]]
		--[[ version = "v2.8.0", ]]
		commit = "95f95e346090ad96c657f021ad4d47f93c915598",
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
		event = "LspAttach",
	},

	{ dir = "~/Code/neotest-elixir", event = "BufReadPre **/test/**/*_test.exs" },
	-- Folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		commit = "9e829d5cfa3de6a2ff561d86399772b0339ae49d",
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
	{ dir = "~/Code/project.nvim" },
	{ "lukas-reineke/indent-blankline.nvim", event = { "BufReadPost", "BufNewFile" } },
	-- This is needed to fix lsp doc highlight
	"antoinemadec/FixCursorHold.nvim",
	"folke/which-key.nvim",
	---------------------
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
	},

	-- Colorschemes
	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	"lunarvim/darkplus.nvim",
	"projekt0n/github-nvim-theme",
	"navarasu/onedark.nvim",
	{ dir = "~/Code/dracula_pro" },
	{ "Mofiqul/dracula.nvim" },

	-- cmp
	{
		"hrsh7th/nvim-cmp",
		commit = "cfafe0a1ca8933f7b7968a287d39904156f2c57d",
		dependencies = {
			{
				"hrsh7th/cmp-nvim-lsp",
				commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
			},
			{
				"hrsh7th/cmp-buffer",
				commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
			},
			{
				"hrsh7th/cmp-path",
				commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
			},
			{
				"hrsh7th/cmp-cmdline",
				commit = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063",
			},
			{
				"saadparwaiz1/cmp_luasnip",
				commit = "18095520391186d634a0045dacaa346291096566",
			},
			{
				"L3MON4D3/LuaSnip",
				commit = "9bff06b570df29434a88f9c6a9cea3b21ca17208",
				event = "InsertEnter",
				dependencies = {
					"rafamadriz/friendly-snippets",
					commit = "a6f7a1609addb4e57daa6bedc300f77f8d225ab7",
				},
			},
			{
				"hrsh7th/cmp-nvim-lua",
				commit = "f3491638d123cfd2c8048aefaf66d246ff250ca6",
			},
		},
		event = {
			"InsertEnter",
			"CmdlineEnter",
		},
	},

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
				},
        panel = {
          keymap = {
            open = "<M-S-CR>",
          }
        }
			})
		end,
	},

	-- Telescope
	{ "nvim-telescope/telescope.nvim", version = "v0.1.1" },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		commit = "3b6c0a6412b31b91eb26bb8f712562cf7bb1d3be",
		event = { "BufReadPost", "BufNewFile" },
	},
})
