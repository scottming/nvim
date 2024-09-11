local util = require("lspconfig.util")

local function is_special_umbrella_project(project)
	return string.find(project, "lexical")
		or string.find(project, "kyc")
		or string.find(project, "ops")
		or string.find(project, "messen")
end

return {
	cmd = { "/Users/scottming/Code/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
	filetypes = { "elixir", "eelixir", "heex" },
	root_dir = function(fname)
		-- Set `~/Code/lexical` as root_dir for lexical project
		local project = util.root_pattern(".git")(fname)
		if project and is_special_umbrella_project(project) then
			return project
		else
			return util.root_pattern("mix.exs", ".git")(fname)
		end
	end,
}
