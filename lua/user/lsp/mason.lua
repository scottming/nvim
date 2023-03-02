local servers = {
	"bashls",
	"jsonls",
	"yamlls",
	"sumneko_lua",
	"html",
	"cssls",
	"emmet_ls",
	-- main languages
	"elixirls",
	"tsserver",
	"pyright",
	"rust_analyzer",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

local ts_on_attach = function(client, bufnr)
	-- https://github.com/typescript-language-server/typescript-language-server/issues/257
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false
	client.server_capabilities.documentRangeFormattingProvider = false
	client.server_capabilities.documentFormattingProvider = false
end

for _, server in pairs(servers) do
	local on_attach
	if server == "tsserver" then
		on_attach = ts_on_attach
	else
		on_attach = require("user.lsp.handlers").on_attach
	end

	if server == "sumneko_lua" then
		-- lua_dev_exist, lua_dev = pcall(require, "lua-dev")
		local lua_dev_exist, lua_dev = pcall(require, "neodev")
		if lua_dev_exist then
			lua_dev.setup({})
		else
			vim.notify("lua-dev load failed")
		end
	end

	opts = {
		on_attach = on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
