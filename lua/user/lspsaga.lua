local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
	return
end

-- change the lsp symbol kind

-- use default config
saga.setup({
	show_outline = {
		win_position = "right",
		--set special filetype win that outline window split.like NvimTree neotree
		-- defx, db_ui
		win_with = "",
		win_width = 50,
		auto_enter = false,
		auto_preview = true,
		virt_text = "┃",
		jump_key = "o",
		-- auto refresh when change buffer
		auto_refresh = true,
	},
	--[[ definition = { ]]
	--[[ 	back = "<C-o>", ]]
 --[[    next = 'gd', ]]
	--[[ }, ]]
	ui = { kind = { ["Folder"] = { " ", "@comment" }, }, },
})
