local M = { "ahmedkhalf/project.nvim", commit = "8c6bad7d22eef1b71144b401c9f74ed01526a4fb", event = "BufEnter" }

local function is_mix_project()
	local cwd = vim.fn.getcwd()
	local uv = vim.loop

	local req = uv.fs_scandir(cwd)
	if req == nil then
		return false
	end

	local is_mix = false

	while true do
		local file = uv.fs_scandir_next(req)

		if file == "mix.exs" then
			is_mix = true
		end

		if file == nil then
			break
		end
	end

	return is_mix
end

function M.config()
	local project = require("project_nvim")

	project.setup({
		---@usage set to false to disable project.nvim.
		--- This is on by default since it's currently the expected behavior.
		active = true,
		on_config_done = nil,
		---@usage set to true to disable setting the current-woriking directory
		--- Manual mode doesn't automatically change your root directory, so you have
		--- the option to manually do so using `:ProjectRoot` command.
		manual_mode = false,
		---@usage Methods of detecting the root directory
		--- Allowed values: **"lsp"** uses the native neovim lsp
		--- **"pattern"** uses vim-rooter like glob pattern matching. Here
		--- order matters: if one is not detected, the other is used as fallback. You
		--- can also delete or rearangne the detection methods.
		-- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
		detection_methods = { "lsp", "pattern" },
		---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
		---@ Show hidden files in telescope when searching for files in a project
		show_hidden = false,
		---@usage When set to false, you will get a message when project.nvim changes your directory.
		-- When set to false, you will get a message when project.nvim changes your directory.
		silent_chdir = false,
		---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
		ignore_lsp = { "lua_ls", "null-ls" },
		---@type string
		---@usage path to store the project history for use in telescope
		datapath = vim.fn.stdpath("data"),
	})

	local tele_status_ok, telescope = pcall(require, "telescope")
	if not tele_status_ok then
		return
	end

	telescope.load_extension("projects")
end

return M
