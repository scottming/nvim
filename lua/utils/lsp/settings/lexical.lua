local function is_special_umbrella_project(project)
	return string.find(project, "lexical")
		or string.find(project, "kyc")
		or string.find(project, "ops")
		or string.find(project, "messen")
end

return {
	cmd = { "/Users/scottming/Code/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
	filetypes = { "elixir", "eelixir", "heex" },
	root_dir = function(bufnr)
		local git_root = vim.fs.root(bufnr, ".git")
		if git_root and is_special_umbrella_project(git_root) then
			return git_root
		else
			return vim.fs.root(bufnr, { "mix.exs", ".git" })
		end
	end,
}
