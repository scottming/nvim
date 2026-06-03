local M = {
	"nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	dependencies = {
		{ "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy" },
		{ "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
	},
}

function M.config()
	local configs = require("nvim-treesitter.configs")

	configs.setup({
		ensure_installed = {
			"lua",
			"markdown",
			"markdown_inline",
			"bash",
			"python",
			"elixir",
			"heex",
			"query",
			"typescript",
			"rust",
		},
		-- auto_install = true,
		-- ensure_installed = "all", -- one of "all" or a list of languages
		ignore_install = { "" }, -- List of parsers to ignore installing
		sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
		auto_install = false,
		modules = {}, -- I don't know what this does
		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "css" }, -- list of language that will be disabled
		},
		injections = {
			enable = true,
		},
		autopairs = {
			enable = true,
		},
		indent = { enable = true, disable = { "python", "css" } },
	})
end

return M
