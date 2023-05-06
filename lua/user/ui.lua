local ok, neotest_config = pcall(require, "neotest.config")
if not ok then
	return " "
end

local utils = require("utils")

local test_strategy = function()
	local cwd = vim.loop.cwd()
	if neotest_config.projects[cwd].default_strategy == "iex" then
		return ""
	else
		return "󰳗"
	end
end

return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "v1.2.0",
	event = "VeryLazy",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	opts = {
		-- configurations go here
		theme = {
			separator = { link = "@comment" },
			dirname = { link = "@comment" },
			basename = { link = "@comment" },
			context_file = { link = "@comment" },
		},

		lead_custom_section = function()
			if utils.is_elixir_test_file() then
				return "  " .. test_strategy() .. " "
			else
				-- return "  " .. "" .. " "
				return "  " .. " " .. " "
			end
		end,
	},
}
