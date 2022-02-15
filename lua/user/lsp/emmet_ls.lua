local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- https://github.com/scottming/emmet-ls/tree/add-elixir-files-support
if not configs.ls_emmet then
	configs.ls_emmet = {
		default_config = {
			cmd = { "emmet-ls", "--stdio" },
			filetypes = {
				"html",
				"css",
				"eelixir",
				"heex",
			},
			root_dir = function(fname)
				return vim.loop.cwd()
			end,
			settings = {},
		},
	}
end

lspconfig.ls_emmet.setup({ capabilities = capabilities })
