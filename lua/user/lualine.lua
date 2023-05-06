local M = { "nvim-lualine/lualine.nvim", commit = "e99d733e0213ceb8f548ae6551b04ae32e590c80", event = "VeryLazy" }

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

-- local branch = {
-- 	"branch",
-- 	icons_enabled = true,
-- 	icon = "",
-- }

local test_strategy = {
	function()
		local ok, neotest_config = pcall(require, "neotest.config")
		if not ok then
			return ""
		end
		local utils = require("utils")
		local cwd = vim.loop.cwd()

		if utils.is_elixir_test_file() then
			if neotest_config.projects[cwd].default_strategy == "iex" then
				return ""
			else
				return "󰳗"
			end
		else
			return ""
		end
	end,
}

local test_status_counts = {
	function()
		local ok, neotest = pcall(require, "neotest")
		if not ok then
			return ""
		end
		local adapters = neotest.state.adapter_ids()

		if #adapters > 0 then
			local status = neotest.state.status_counts(adapters[1], {
				buffer = vim.api.nvim_buf_get_name(0),
			})
			local sections = {
				{
					sign = "",
					count = status.failed,
					base = "NeotestFailed",
					tag = "test_fail",
				},
				{
					sign = "",
					count = status.running,
					base = "NeotestRunning",
					tag = "test_running",
				},
				{
					sign = "",
					count = status.passed,
					base = "NeotestPassed",
					tag = "test_pass",
				},
				{
					sign = "󰙨",
					count = status.total,
					base = "NeotestTotal",
					tag = "test_total",
				},
			}

			local result = {}
			for _, section in ipairs(sections) do
				if section.count > 0 then
					table.insert(result, "%#" .. section.base .. "#" .. section.sign .. " " .. section.count)
				end
			end

			return table.concat(result, " ")
		end
		return ""
	end,
}

local location = {
	"location",
	padding = 0,
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

function M.config()
	local lualine = require("lualine")

	lualine.setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
			always_divide_middle = true,
		},
		sections = {
			lualine_a = { diagnostics },
			lualine_b = { mode },
			lualine_c = { test_status_counts },
			-- lualine_x = { "encoding", "fileformat", "filetype" },
			--[[ lualine_x = { diff, spaces, "encoding", filetype }, ]]
			lualine_x = { diff, spaces, filetype },
			lualine_y = { test_strategy, location },
			lualine_z = { progress },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		extensions = {},
	})
end

return M
