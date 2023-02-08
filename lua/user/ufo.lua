-- folding
-- when only compile nvim at local
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
local language_servers = {} -- like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
	require("lspconfig")[ls].setup({
		capabilities = capabilities,
		other_fields = ...,
	})
end

require("ufo").setup()
