local neotest = require("neotest")
local neotest_config = require("neotest.config")
local null_ls = require("null-ls")
local null_ls_sources = require("null-ls.sources")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

local function dbg_registered()
	local registered = null_ls_sources.get_all()
	for _, v in pairs(registered) do
		if v.name == "dbg" then
			return true
		end
	end
	return false
end

local function dbg_switch()
	if dbg_registered() then
		return " dbg"
	else
		return " dbg"
	end
end

local function strategy_switch(strategy)
	if strategy == "integrated" then
		return " iex"
	else
		return "󰳗 integrated"
	end
end

local function config_neotest_strategy(cwd, strategy)
	neotest.setup_project(cwd, {
		adapters = { require("neotest-elixir") },
		default_strategy = strategy,
	})
end

local function toggle_dbg()
	if dbg_registered() then
		null_ls.deregister("dbg")
		print("Unregistered dbg code actions")
	else
		local custom = require("user.lsp.code_actions")
		null_ls.register({ custom.elixir_dbg })
		print("Registered dbg code actions")
	end
end

M.strategies = function(opts)
	local cwd = vim.loop.cwd()
	local project = string.match(cwd, ".*%/(.*)")
	local default_strategy = neotest_config.projects[cwd].default_strategy
	local switch_strategy = (default_strategy == "integrated") and "iex" or "integrated"

	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = project .. " - Config Test Strategies/Tools",
			finder = finders.new_table({
				results = {
					{ switch_strategy, "strategy" },
					{ "dbg", "dbg" },
				},
				entry_maker = function(entry)
					local display = (entry[2] == "strategy") and strategy_switch(default_strategy) or dbg_switch()
					return {
						value = entry,
						display = display,
						ordinal = entry[1],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local kind = selection.value[2]

					if kind == "strategy" then
						local strategy = selection.value[1]
						config_neotest_strategy(cwd, strategy)
						print("Configured " .. strategy .. " for: " .. cwd)
					else
						toggle_dbg()
					end
				end)
				return true
			end,
		})
		:find()
end

return M
