return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "v3.27",
	event = "BufWinEnter",
	opts = function(_, opts)
		opts.window = {
			mappings = {
				["l"] = "open",
				["h"] = "close_node",
			},
		}
		opts.filesystem = {
			follow_current_file = { enabled = true },
		}
		opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
			or { "terminal", "Trouble", "qf", "Outline", "trouble" }
		table.insert(opts.open_files_do_not_replace_types, "edgy")
	end,
}
