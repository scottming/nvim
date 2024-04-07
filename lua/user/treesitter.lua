local M = {
	"nvim-treesitter/nvim-treesitter",
	commit = "226c1475a46a2ef6d840af9caa0117a439465500",
	event = "BufReadPost",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "VeryLazy",
			commit = "7f625207f225eea97ef7a6abe7611e556c396d2f",
		},
		{
			"nvim-tree/nvim-web-devicons",
			event = "VeryLazy",
			commit = "0568104bf8d0c3ab16395433fcc5c1638efc25d4",
		},
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
		auto_install = true,
		-- ensure_installed = "all", -- one of "all" or a list of languages
		ignore_install = { "" }, -- List of parsers to ignore installing
		sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "css" }, -- list of language that will be disabled
		},
		autopairs = {
			enable = true,
		},
		indent = { enable = true, disable = { "python", "css" } },

		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
	})
end

return M
