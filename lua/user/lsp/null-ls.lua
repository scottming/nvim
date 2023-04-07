local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local custom = require("user.lsp.code_actions")

local add_dbg = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = { "elixir" },
	generator = { fn = custom.add_dbg },
}

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
		add_dbg,
	},
})

-- set custom actions
require("user.lsp.code_actions")
