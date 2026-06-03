return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = "BufReadPre",
	opts = {
		indent = {
			char = "▏",
		},
		scope = {
			enabled = true,
		},
		exclude = {
			buftypes = { "terminal", "nofile" },
			filetypes = {
				"help",
				"neo-tree",
				"neo-tree-popup",
				"alpha",
				"Trouble",
				"lazy",
			},
		},
	},
}
