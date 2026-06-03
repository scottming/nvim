local M = {
	"williamboman/mason.nvim",
	cmd = "Mason",
	event = "BufReadPre",
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
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

local mason_excluded = { "lexical", "expert" }

local function exclude_servers(tbl, excluded)
	local skip = {}
	for _, name in ipairs(excluded) do
		skip[name] = true
	end
	local result = {}
	for _, value in ipairs(tbl) do
		if not skip[value] then
			table.insert(result, value)
		end
	end
	return result
end

function M.config()
	require("mason").setup(settings)
	require("mason-lspconfig").setup({
		ensure_installed = exclude_servers(servers, mason_excluded),
		automatic_installation = true,
		automatic_enable = false,
	})
end

return M
