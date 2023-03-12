--[[ return { ]]
--[[ 	cmd = { "/Users/scottming/Code/lexical/_build/prod/rel/lexical/start_lexical.sh" }, ]]
--[[ 	filetypes = { "elixir", "eelixir", "heex", "surface" }, ]]
--[[ 	settings = {}, ]]
--[[ } ]]

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local lexical = {
	cmd = { "/Users/scottming/Code/lexical/_build/prod/rel/lexical/start_lexical.sh" },
	filetypes = { "elixir", "eelixir", "heex", "surface" },
	settings = {},
}

local custom_attach = function()
	print("Lexical has started.")
end

if not configs.lexical then
	configs.lexical = {
		default_config = {
			cmd = lexical.cmd,
			filetypes = lexical.filetypes,
			settings = lexical.settings,
		},
	}
end

lspconfig.lexical.setup({
	capabilities = require("user.lsp.handlers").capabilities, -- optional
	on_attach = custom_attach,
	root_dir = lspconfig.util.root_pattern("mix.exs", ".git") or vim.loop.os_homedir(),
})
