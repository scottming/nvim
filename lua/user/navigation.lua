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
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
		event = "BufEnter",
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
