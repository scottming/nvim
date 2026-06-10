local elixir_root = require("utils.lsp.elixir_root")

return {
	cmd = { "/Users/scottming/Code/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
	filetypes = { "elixir", "eelixir", "heex" },
	root_dir = function(bufnr, on_dir)
		on_dir(elixir_root.resolve_root(bufnr))
	end,
}
