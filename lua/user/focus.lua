local M = {
	"beauwilliams/focus.nvim",
	commit = "3d9df42aa4f9b572348418207b752f81adea09a5",
	event = "VeryLazy",
}

function M.config()
	local focus = require("focus")
	focus.setup({
		excluded_filetypes = { "toggleterm", "NvimTree", "undotree" },
		cursorline = false,
		number = false,
		signcolumn = false,
		colorcolumn = { enable = false, width = 80 },
	})
end

return M
