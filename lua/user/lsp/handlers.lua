local M = {}

M.setup = function()
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
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	-- keymap
	local opts = { silent = true }
	vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.keymap.set("n", "gp", "<cmd>Lspsaga preview_definition<CR>", { silent = true })

	-- hover
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
	local action = require("lspsaga.action")
	-- scroll down hover doc or scroll in definition preview
	vim.keymap.set("n", "<C-f>", function()
		action.smart_scroll_with_saga(1)
	end, { silent = true })
	-- scroll up hover doc
	vim.keymap.set("n", "<C-b>", function()
		action.smart_scroll_with_saga(-1)
	end, { silent = true })

	-- signature
	vim.keymap.set("n", "gs", "<Cmd>Lspsaga signature_help<CR>", { silent = true })

	-- rename
	vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

	-- or use command
	vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
	vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
  vim.keymap.set("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
end

return M
