local elixir_root = require("utils.lsp.elixir_root")

return {
	cmd = { "/Users/scottming/Code/expert/apps/expert/_build/prod/rel/plain/bin/start_expert", "--stdio" },
	filetypes = { "elixir", "eelixir", "heex" },
	root_dir = function(bufnr, on_dir)
		local git_root = vim.fs.root(bufnr, ".git")
		if git_root and elixir_root.is_special_umbrella(git_root) then
			on_dir(git_root)
		else
			on_dir(vim.fs.root(bufnr, { "mix.exs", ".git" }))
		end
	end,
}
