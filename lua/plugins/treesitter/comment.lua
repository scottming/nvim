local M = {
	"numToStr/Comment.nvim",
	commit = "eab2c83a0207369900e92783f56990808082eac2",
	event = "BufRead",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "VeryLazy",
		},
	},
}

function M.config()
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})

	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})
end

return M
