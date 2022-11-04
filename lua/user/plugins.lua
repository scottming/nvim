local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use({ "glepnir/lspsaga.nvim", commit = "e5d5a3243616af78f0d7b7b29aa700a16e516a23" })
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

	-- Debug
	use("mfussenegger/nvim-dap")
	use("mfussenegger/nvim-dap-python")
	use("jbyuki/one-small-step-for-vimkind")

	-- Treesitter
	use("nvim-treesitter/playground")
	use({
		"nvim-treesitter/nvim-treesitter",
		commit = "addc129a4f272aba0834bd0a7b6bd4ad5d8c801b",
		run = ":TSUpdate",
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")

  -- symbols
	use({
		"scottming/symbols-outline.nvim",
		--[[ commit = "e459f3262c4c79a62e654ada0fbbb9758313c968", ]]
		branch = "support-elixir-private-functions",
		config = function()
			require("symbols-outline").setup()
		end,
	})

	-- Test
	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"jfpedroza/neotest-elixir",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-plenary",
			"rouge8/neotest-rust",
		},
	})

	-- Folding
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

	-- move faster
	use({
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	})

	-- resize window when use
	use("kwkarlwang/bufresize.nvim")

	-- vimscript plugins
	use("vim-test/vim-test")
	use("tpope/vim-surround")
	-- bdelete, <leader>c
	use("moll/vim-bbye")
	use("tpope/vim-projectionist")
	-- maximize the window by <leader>z
	use("szw/vim-maximizer")

	use("wbthomason/packer.nvim") -- Have packer manage itself
	--[[ use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim ]]
	--[[ use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins ]]

	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")

	-- Basic plugins
	---------------------
	-- Autopairs, integrates with both cmp and treesitter
	use("windwp/nvim-autopairs")
	-- Easily comment stuff
	use("numToStr/Comment.nvim")
	-- improve startup time
	use("lewis6991/impatient.nvim")
	-- bufferline, lualine
	use({ "akinsho/bufferline.nvim", tag = "v2.8.0" })
	use("nvim-lualine/lualine.nvim") -- status line plugin
	use({ "akinsho/toggleterm.nvim", tag = "v2.1.0" })
	-- project manager
	use("ahmedkhalf/project.nvim")
	use("goolord/alpha-nvim")
	use("lukas-reineke/indent-blankline.nvim")
	-- This is needed to fix lsp doc highlight
	use("antoinemadec/FixCursorHold.nvim")
	use("folke/which-key.nvim")
	---------------------

	-- Colorschemes
	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	use("lunarvim/darkplus.nvim")
	use("projekt0n/github-nvim-theme")
	use("navarasu/onedark.nvim")

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use({
		"tzachar/cmp-tabnine",
		config = function()
			local tabnine = require("cmp_tabnine.config")
			tabnine:setup({
				max_lines = 1000,
				max_num_results = 20,
				sort = true,
			})
		end,
	})

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- Telescope
	use("nvim-telescope/telescope.nvim")

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
