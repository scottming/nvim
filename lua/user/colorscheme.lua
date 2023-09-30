local M = {
	{ "navarasu/onedark.nvim", lazy = false, priority = 800 },
	{ dir = "~/Code/dracula_pro", lazy = false, priority = 1000 },
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = { style = "moon" },
	},
}

M.name = "dracula_pro_buffy"
-- M.name = "dracula_pro_morbius"
-- M.name = "onedark"

return M
