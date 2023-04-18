local M = {
	"akinsho/bufferline.nvim",
	commit = "c7492a76ce8218e3335f027af44930576b561013",
	event = { "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
	dependencies = {
		{
			"famiu/bufdelete.nvim",
			commit = "8933abc09df6c381d47dc271b1ee5d266541448e",
		},
	},
}

function M.config()
	local styles = require("utils.styles")
	local icons = styles.style.icons
	local bufferline = require("bufferline")

	bufferline.setup({
		options = {
			debug = { logging = true },
			mode = "buffers", -- tabs
			sort_by = "insert_after_current",
			right_mouse_command = "vert sbuffer %d",
			show_close_icon = false,
			indicator = { style = "none" },
			show_buffer_close_icons = false,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level)
				return (icons[level] or "?") .. " " .. count
			end,
			diagnostics_update_in_insert = false,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "center",
				},
			},
		},
	})
end

return M
