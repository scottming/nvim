local function is_special_umbrella_project(project)
	return string.find(project, "lexical")
		or string.find(project, "kyc")
		or string.find(project, "ops")
		or string.find(project, "messen")
end

return {
	cmd = { "/Users/scottming/Code/expert/apps/expert/_build/prod/rel/plain/bin/start_expert", "--stdio" },
	filetypes = { "elixir", "eelixir", "heex" },
	root_dir = function(bufnr, on_dir)
		local git_root = vim.fs.root(bufnr, ".git")
		if git_root and is_special_umbrella_project(git_root) then
			on_dir(git_root)
		else
			on_dir(vim.fs.root(bufnr, { "mix.exs", ".git" }))
		end
	end,
}
