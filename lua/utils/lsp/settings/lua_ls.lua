return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					--[[ [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true, ]]
					[vim.fn.stdpath("config") .. "/lua"] = true,
					[vim.fn.stdpath("data") .. "/lazy/neotest"] = true,
					[vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"] = true,
					-- for developing neotest
				},
				checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
			},
			telemetry = {
				enable = false,
			},

			format = {
				enable = false,
			},
		},
	},
}
