local M = {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		"nvim-treesitter/nvim-treesitter",
	},
	commit = "203c9f434feec57909ab4b1e028abeb3349b7847",
	event = "BufEnter",
}

function M.config()
	local ufo = require("ufo")

	vim.o.foldcolumn = "0" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true
	vim.o.statuscolumn = " %s%=%l "
	-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

	-- these are "extra", change them as you like
	vim.keymap.set("n", "zR", require("ufo").openAllFolds)
	vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

	ufo.setup({
		---@diagnostic disable-next-line: unused-local
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
	})
end

return M
