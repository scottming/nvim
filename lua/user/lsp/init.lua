local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("user.lsp.mason")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")

-- log
require("vim.lsp.log").set_format_func(vim.inspect)
--[[ vim.lsp.set_log_level("debug") ]]

-- another elixir language server
require("user.lsp.settings.lexical")
