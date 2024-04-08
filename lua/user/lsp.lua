local M = {
	"neovim/nvim-lspconfig",
	commit = "9619e53d3f99f0ca4ea3b88f5d97fce703131820",
	lazy = true,
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
			event = "LspAttach",
		},
		{ "nvimdev/lspsaga.nvim", event = "LspAttach", commit = "a4d442896a9ff1f83ee3db965d81b659ebc977d5" },
		{ "j-hui/fidget.nvim", event = "LspAttach", commit = "0ba1e16d07627532b6cae915cc992ecac249fb97" },
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
		symbol_in_winbar = { enable = false },
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
		-- disable it, and if you really need them,
		-- you can use `gl` to show the diagnostic float window.
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

function M.config()
	-- setup lspsaga and config diagnostic
	setup_lspsaga()
	config_diagnostic()
	require("fidget").setup({
		timer = {
			spinner_rate = 125, -- frame rate of spinner animation, in ms
			-- fidget_decay = 2000, -- how long to keep around empty fidget, in ms
			fidget_decay = 500,
			-- task_decay = 1000, -- how long to keep around completed task, in ms
			task_decay = 250,
		},
		window = {
			blend = 50,
		},
		sources = {
			["null-ls"] = { ignore = true },
		},
	})

	-- log
	-- vim.lsp.set_log_level("debug")
	require("vim.lsp.log").set_format_func(vim.inspect)

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
