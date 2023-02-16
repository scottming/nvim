local status_ok, focus = pcall(require, "focus")
if not status_ok then
	return
end

focus.setup({
	excluded_filetypes = { "toggleterm", "NvimTree" },
	cursorline = false,
	number = false,
	signcolumn = false,
	colorcolumn = { enable = true, width = tonumber(vim.o.colorcolumn) },
})
