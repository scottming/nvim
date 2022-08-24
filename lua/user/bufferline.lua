local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

local styles = require("user.styles")
local icons = styles.style.icons

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
