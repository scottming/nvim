local neotest = require("neotest")
local neotest_config = require("neotest.config")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

local function strategy_switch(strategy)
	if strategy == "integrated" then
		return " iex"
	else
		return "󰳗 integrated"
	end
end

local function config_neotest_strategy(strategy)
	local cwd = vim.uv.cwd()
	neotest.setup_project(cwd, {
		adapters = { require("neotest-elixir") },
		default_strategy = strategy,
	})
	_G.neotest_strategy_manually = true
end

M.strategies = function(opts)
	local cwd = vim.uv.cwd()
	local project = string.match(cwd, ".*%/(.*)")
	local default_strategy = neotest_config.projects[cwd].default_strategy
	local switch_strategy = (default_strategy == "integrated") and "iex" or "integrated"

	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = project .. " - Config Test Strategies",
			finder = finders.new_table({
				results = {
					{ switch_strategy, "strategy" },
				},
				entry_maker = function(entry)
					return {
						value = entry,
						display = strategy_switch(default_strategy),
						ordinal = entry[1],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local strategy = selection.value[1]
					config_neotest_strategy(strategy)
					print("Configured " .. strategy .. " for: " .. cwd)
				end)
				return true
			end,
		})
		:find()
end

return M
