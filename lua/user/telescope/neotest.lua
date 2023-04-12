local neotest = require("neotest")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.strategies = function(opts)
	local cwd = vim.loop.cwd()
	local project = string.match(cwd, ".*%/(.*)")

	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = project .. " - Select test strategy",
			finder = finders.new_table({
				results = {
					{ "iex", "iex" },
					{ "integrated", "integrated" },
				},
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry[1],
						ordinal = entry[1],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()

					local strategy = selection.value[2]

					neotest.setup_project(cwd, {
						adapters = { require("neotest-elixir") },
						default_strategy = strategy,
					})

					print("Configured " .. strategy .. " for: " .. cwd)
				end)
				return true
			end,
		})
		:find()
end

return M
