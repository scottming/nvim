return {
	{
		"ggandor/flit.nvim",
		keys = function()
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx", multiline = false },
		event = "BufEnter",
	},
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n" }, desc = "Leap from windows" },
		},
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
			vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
		end,
	},
	-- {
	-- 	"nvim-focus/focus.nvim",
	-- 	commit = "1e2752aa3233497a17640e6474dbd6b35aaeeb26",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		local focus = require("focus")
	-- 		focus.setup({})
	-- 	end,
	-- },
}
