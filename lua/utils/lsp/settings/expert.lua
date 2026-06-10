local elixir_root = require("utils.lsp.elixir_root")

return {
	cmd = { "/Users/scottming/Code/expert/apps/expert/_build/prod/rel/plain/bin/start_expert", "--stdio" },
	filetypes = { "elixir", "eelixir", "heex" },
	root_dir = function(bufnr, on_dir)
		on_dir(elixir_root.resolve_root(bufnr))
	end,
}
