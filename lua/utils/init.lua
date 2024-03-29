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

M.is_elixir_test_file = function()
	local file_name = vim.fn.expand("%:t")
	return file_name:match("_test%.exs$") ~= nil
end

M.set_iex_strategy = function()
	local neotest = require("neotest")
	local cwd = vim.loop.cwd()
	neotest.setup_project(cwd, {
		adapters = { require("neotest-elixir") },
		default_strategy = "iex",
	})
end

return M
