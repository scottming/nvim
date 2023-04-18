local M = { "jose-elias-alvarez/null-ls.nvim", commit = "456cd2754c56c991c5e4df60a807d054c1bc7148", event = "VeryLazy" }

function M.config()
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
	local diagnostics = null_ls.builtins.diagnostics

	local custom_code_actions = require("utils.lsp.code_actions")

	null_ls.setup({
		debug = false,
		sources = {
			-- 1. lua: stylua
			-- 2. ts: prettier
			-- 3. python: black, flake8
			-- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
			formatting.stylua,
			formatting.prettier.with({}),
			formatting.black.with({ extra_args = { "--fast" } }),
			diagnostics.flake8,
			custom_code_actions.elixir_dbg,
		},
	})
end

return M
