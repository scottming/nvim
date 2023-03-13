--[[ return { ]]
--[[ 	cmd = { "/Users/scottming/Code/lexical/_build/prod/rel/lexical/start_lexical.sh" }, ]]
--[[ 	filetypes = { "elixir", "eelixir", "heex", "surface" }, ]]
--[[ 	settings = {}, ]]
--[[ } ]]

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local lexical = {
	filetypes = { "elixir", "eelixir", "heex", "surface" },
	cmd = { "/Users/scottming/Code/lexical/_build/prod/rel/lexical/start_lexical.sh" },
	settings = {},
}

local custom_attach = function()
	print("Lexical has started.")
end

if not configs.lexical then
	configs.lexical = {
		default_config = {
			filetypes = lexical.filetypes,
			root_dir = function(fname)
				return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
			end,
		},
	}
end

lspconfig.lexical.setup({
	capabilities = require("user.lsp.handlers").capabilities, -- optional
	on_attach = custom_attach,
	settings = lexical.settings,
	cmd = lexical.cmd,
	root_dir = function(fname)
		return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
	end,
})
