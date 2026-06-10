local M = { "nvim-lualine/lualine.nvim", commit = "e99d733e0213ceb8f548ae6551b04ae32e590c80", event = "VeryLazy" }

local icons = require("utils.styles").style.icons

local function hide_in_width()
	return vim.fn.winwidth(0) > 80
end

-- static components
local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = icons.lsp.error .. " ", warn = icons.lsp.warn .. " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = {
		added = icons.git.add .. " ",
		modified = icons.git.mod .. " ",
		removed = icons.git.remove .. " ",
	},
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

local location = { "location", padding = 0 }

local progress_chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }

local function progress()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local index = math.ceil((current_line / total_lines) * #progress_chars)
	return progress_chars[index]
end

local function spaces()
	return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", { buffer = 0 })
end

-- neotest components
local neotest_status_sections = {
	{ sign = "", field = "failed", base = "NeotestFailed" },
	{ sign = "", field = "running", base = "NeotestRunning" },
	{ sign = "", field = "passed", base = "NeotestPassed" },
	{ sign = "󰙨", field = "total", base = "NeotestTotal" },
}

local function format_neotest_status(status)
	local parts = {}
	for _, section in ipairs(neotest_status_sections) do
		local count = status[section.field]
		if count > 0 then
			table.insert(parts, "%#" .. section.base .. "#" .. section.sign .. " " .. count)
		end
	end
	return table.concat(parts, " ")
end

local function neotest_strategy_label()
	local ok, neotest_config = pcall(require, "neotest.config")
	if not ok or not require("utils").is_elixir_test_file() then
		return ""
	end

	local project = neotest_config.projects[vim.uv.cwd()]
	if not project then
		return ""
	end

	return project.default_strategy == "iex" and "" or "󰳗"
end

local function neotest_status_label()
	local ok, neotest = pcall(require, "neotest")
	if not ok then
		return ""
	end

	local adapters = neotest.state.adapter_ids()
	if #adapters == 0 then
		return ""
	end

	local status = neotest.state.status_counts(adapters[1], {
		buffer = vim.api.nvim_buf_get_name(0),
	})
	return format_neotest_status(status)
end

local test_strategy = { neotest_strategy_label }
local test_status_counts = { neotest_status_label }

function M.config()
	require("lualine").setup({
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
