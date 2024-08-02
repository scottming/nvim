local M = {
	"williamboman/mason.nvim",
	commit = "e2f7f9044ec30067bc11800a9e266664b88cda22",
	cmd = "Mason",
	event = "BufReadPre",
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			commit = "ba9c2f0b93deb48d0a99ae0e8d8dd36f7cc286d6",
			lazy = true,
		},
	},
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

local servers = require("utils.lsp").servers

local function remove_item(tbl, item)
	local new_tbl = {}
	for _, value in ipairs(tbl) do
		if value ~= item then
			table.insert(new_tbl, value)
		end
	end
	return new_tbl
end

function M.config()
	require("mason").setup(settings)
	require("mason-lspconfig").setup({
		ensure_installed = remove_item(servers, "lexical"),
		automatic_installation = true,
	})
end

return M
