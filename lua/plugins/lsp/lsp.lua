local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp", event = "LspAttach" },
		{ "nvimdev/lspsaga.nvim", event = "LspAttach" },
		{ "j-hui/fidget.nvim", event = "LspAttach" },
	},
}

local function setup_lspsaga()
	local saga = require("lspsaga")

	saga.setup({
		outline = {
			win_position = "right",
			--set special filetype win that outline window split.like NvimTree neotree
			-- defx, db_ui
			win_with = "",
			win_width = 50,
			auto_enter = false,
			auto_preview = false,
			virt_text = "┃",
			jump_key = "o",
			-- auto refresh when change buffer
			auto_refresh = true,
		},
		lightbulb = {
			enable = false,
			enable_in_insert = false,
			virtual_text = true,
		},
		ui = { kind = { ["Folder"] = "@comment" } },
		symbol_in_winbar = { enable = false },
	})
end

local function config_diagnostic()
	vim.diagnostic.config({
		-- disable it, and if you really need them,
		-- you can use `gl` to show the diagnostic float window.
		virtual_text = false,
		signs = require("utils.styles").diagnostic_signs(),
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			header = "",
			prefix = "",
		},
	})
end

-- Lsp keymaps only works after lsp client attached
local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap

	-- finder and preview
	keymap(bufnr, "n", "gh", "<cmd>Lspsaga finder<CR>", opts)
	keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

	-- hover
	keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

	-- action
	keymap(bufnr, "n", "<a-cr>", "<cmd>Lspsaga code_action<cr>", { silent = true })
	keymap(bufnr, "n", "<F15>", "<cmd>Lspsaga code_action<cr>", { silent = true })
	-- Just for neovide

	-- signature
	-- keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true })

	-- rename
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })

	-- or use command
	keymap(bufnr, "n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
	keymap(bufnr, "n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true })
end

local function setup_fidget()
	require("fidget").setup({
		notification = { window = { winblend = 50 } },
	})
end

local function setup_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	vim.lsp.config("*", { capabilities = capabilities })
end

local function setup_attach()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			lsp_keymaps(args.buf)
		end,
	})
end

local function enable_servers()
	local servers = require("utils.lsp").servers
	local server_names = {}

	for _, server in pairs(servers) do
		local name = vim.split(server, "@")[1]
		table.insert(server_names, name)

		local require_ok, conf_opts = pcall(require, "utils.lsp.settings." .. name)
		if require_ok then
			vim.lsp.config(name, conf_opts)
		end
	end

	vim.lsp.enable(server_names)
end

function M.config()
	setup_lspsaga()
	config_diagnostic()
	setup_fidget()
	require("vim.lsp.log").set_format_func(vim.inspect)
	setup_capabilities()
	setup_attach()
	enable_servers()
end

return M
