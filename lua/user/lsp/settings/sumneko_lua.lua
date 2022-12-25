return {
	settings = {

		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				preloadFileSize = 500,

				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					-- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},

			completion = {
				callSnippet = "Replace",
			},

			format = {
				enable = false,
			},
		},
	},
}
