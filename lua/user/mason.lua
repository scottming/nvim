local M = {
	"williamboman/mason.nvim",
	commit = "4546dec8b56bc56bc1d81e717e4a935bc7cd6477",
	cmd = "Mason",
	event = "BufReadPre",
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			commit = "93e58e100f37ef4fb0f897deeed20599dae9d128",
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
