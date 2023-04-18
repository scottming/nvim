local M = {
	"neovim/nvim-lspconfig",
	commit = "649137cbc53a044bffde36294ce3160cb18f32c7",
	lazy = true,
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
		},
		{ dir = "~/Code/lspsaga.nvim" },
		{ dir = "~/Code/lspsaga-mini.nvim" },
	},
}

local function setup_lspsaga()
	local saga = require("lspsaga")

	saga.setup({
		show_outline = {
			win_position = "right",
			--set special filetype win that outline window split.like NvimTree neotree
			-- defx, db_ui
			win_with = "",
			win_width = 50,
			auto_enter = false,
			auto_preview = true,
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
	})
end

local function config_diagnostic()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			-- source = "always",
			header = "",
			prefix = "",
		},
		ui = { kind = { ["Folder"] = "@comment" } },
	}
	vim.diagnostic.config(config)
end

-- Lsp keymaps only works after lsp client attached
local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap

	-- finder and preview
	keymap(bufnr, "n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
	keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	-- keymap(bufnr, "n", "gp", "<cmd>lua require('lspsaga-mini.definition'):peek_definition(1)<CR>", { silent = true })

	-- hover
	keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

	-- action
	keymap(bufnr, "n", "<a-cr>", "<cmd>Lspsaga code_action<cr>", { silent = true })
	keymap(bufnr, "n", "<F15>", "<cmd>Lspsaga code_action<cr>", { silent = true })
	-- Just for neovide

	-- signature
	keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true })

	-- rename
	keymap(bufnr, "n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

	-- or use command
	keymap(bufnr, "n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
	keymap(bufnr, "n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true })
end

function M.config()
	-- setup lspsaga and config diagnostic
	setup_lspsaga()
	config_diagnostic()

	-- cmp
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

	-- lsp config
	local lspconfig = require("lspconfig")

	local on_attach = function(client, bufnr)
		if client.name == "tsserver" then
			client.server_capabilities.documentFormattingProvider = false
		end

		if client.name == "sumneko_lua" then
			client.server_capabilities.documentFormattingProvider = false
		end

		lsp_keymaps(bufnr)

		-- NTOE: use this require line elixir files won't work
		-- maybe because of the find reference not provide by lexical
		-- require("illuminate").on_attach(client)
	end

	-- load custom lsp server to lspconfig first(i.e: lexical)
	require("utils.lsp.settings.lexical").load_lexical()

	for _, server in pairs(require("utils.lsp").servers) do
		Opts = {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		server = vim.split(server, "@")[1]

		local require_ok, conf_opts = pcall(require, "utils.lsp.settings." .. server)
		if require_ok then
			Opts = vim.tbl_deep_extend("force", conf_opts, Opts)
		end

		lspconfig[server].setup(Opts)
	end
end

return M
