local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- example using a list of specs with the default options
vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct

local colorscheme_name = require("user.colorscheme").name

-- load lazy
require("lazy").setup("user", {
	install = { colorscheme = { colorscheme_name } },
	defaults = { lazy = true, version = "v11.11.1" },
	ui = { wrap = "true" },
	checker = { enabled = false },
	change_detection = { enabled = false },
	debug = false,
	performance = {
		rtp = {
			disabled_plugins = {},
		},
	},
})

vim.cmd.colorscheme(colorscheme_name)

if colorscheme_name == "onedark" then
	require("onedark").setup({ style = "cool" })
	require("onedark").load()
end
