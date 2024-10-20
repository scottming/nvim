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
	-- winbar tool
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "v1.2.0",
	event = "VeryLazy",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	opts = {
		theme = {
			-- Get the comment fg color
			-- local hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
			-- local "#9f70a9"
			-- if hl.fg then
			-- 	"#9f70a9" = string.format("#%06x", hl.fg)
			-- end

			-- Because Dracula doesn’t load fast enough, a static value is needed here.
			separator = { fg = "#9f70a9" },
			dirname = { fg = "#9f70a9" },
			basename = { fg = "#9f70a9" },
			context_file = { fg = "#9f70a9" },
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
