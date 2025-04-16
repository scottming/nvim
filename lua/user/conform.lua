return {
	"stevearc/conform.nvim",
	event = "BufRead",
	opts = {
		formatters_by_ft = {
			-- Conform will run the first available formatter
			seex = { "prettierd", "prettier", stop_after_first = true },
		},
	},
	version = "v8.4.0",
}
