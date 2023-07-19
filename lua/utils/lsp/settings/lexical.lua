local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local M = {
	filetypes = { "elixir", "eelixir", "heex", "surface" },
	cmd = { "/Users/scottming/Code/lexical/_build/dev/rel/lexical/start_lexical.sh" },
	settings = {},
}

local function is_special_umbrella_project(project)
	return string.find(project, "lexical") or string.find(project, "kyc") or string.find(project, "ops")
end

function M.load_lexical()
	if not configs.lexical then
		configs.lexical = {
			default_config = {
				filetypes = M.filetypes,
				root_dir = function(fname)
					-- Set `~/Code/lexical` as root_dir for lexical project
					local project = lspconfig.util.root_pattern(".git")(fname)
					if project and is_special_umbrella_project(project) then
						return project
					else
						return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
					end
				end,
			},
		}
	end
end

return M
