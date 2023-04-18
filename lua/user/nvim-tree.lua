local M = {
	-- { "nvim-tree/nvim-web-devicons", commit = "c3c1dc4e36969370ff589b7025df8ec2e5c881a2", event = 'VimEnter' },
	"nvim-tree/nvim-tree.lua",
	commit = "bbb6d4891009de7dab05ad8fc2d39f272d7a751c",
	event = "VimEnter",
}

function M.config()
	local nvim_tree = require("nvim-tree")
	local nvim_tree_config = require("nvim-tree.config")
	local tree_cb = nvim_tree_config.nvim_tree_callback

	nvim_tree.setup({
		disable_netrw = true,
		hijack_netrw = true,
		open_on_tab = false,
		hijack_cursor = false,
		update_cwd = true,
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		diagnostics = {
			enable = true,
			icons = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			},
		},
		update_focused_file = {
			enable = true,
			update_cwd = false,
			ignore_list = {},
		},
		system_open = {
			cmd = nil,
			args = {},
		},
		filters = {
			dotfiles = false,
			custom = {},
		},
		git = {
			enable = true,
			ignore = true,
			timeout = 500,
		},
		view = {
			width = 30,
			--[[ height = 30, ]]
			hide_root_folder = false,
			side = "left",
			mappings = {
				custom_only = false,
				list = {
					{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
					{ key = "h", cb = tree_cb("close_node") },
					{ key = "v", cb = tree_cb("vsplit") },
				},
			},
			number = false,
			relativenumber = false,
		},
		trash = {
			cmd = "trash",
			require_confirm = true,
		},
		actions = {
			open_file = {
				resize_window = true,
				quit_on_open = false,
				window_picker = {
					enable = true,
				},
			},
		},
		renderer = {
			icons = {
				glyphs = {
					default = "",
					symlink = "",
					git = {
						unstaged = "",
						staged = "S",
						unmerged = "",
						renamed = "➜",
						deleted = "",
						untracked = "U",
						ignored = "◌",
					},
					folder = {
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
					},
				},
			},
		},
	})
end

return M
