local M = {}

M.win_up = function()
	local last_focus = vim.g.last_focus_win_number
	-- when there is a focus and the focus is not the current window
	if last_focus and last_focus ~= vim.fn.winnr() then
		-- id is dynamic, so we need to get it every time
		local last_focus_win_id = vim.fn.win_getid(last_focus)
		vim.fn.win_gotoid(last_focus_win_id)
	else
		vim.cmd("wincmd k")
	end
end

M.win_down = function()
	if vim.fn.winnr("$") ~= vim.fn.winnr() then
		vim.g.last_focus_win_number = vim.fn.winnr()
		vim.cmd("wincmd j")
	else
		-- when the last focus is in the bottom window
		vim.cmd("wincmd j")
	end
end

M.set_iex = function()
	local neotest = require("neotest")
	local neotest_config = require("neotest.config")

	local cwd = vim.loop.cwd()
	local default_strategy = neotest_config.projects[cwd].default_strategy
	if default_strategy == "integrated" then
		neotest.setup_project(cwd, {
			default_strategy = "iex",
		})
	end
end

return M
