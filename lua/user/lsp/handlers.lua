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
	vim.keymap.set("n", "gp", "<cmd>lua require('lspsaga-mini.definition'):peek_definition(1)<CR>", { silent = true })

	-- hover
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

	-- make the hover window close when pressing q
	vim.keymap.set("n", "q", function()
		local hover = require("lspsaga.hover")
		if hover:has_hover() then
			vim.api.nvim_win_close(hover.preview_winid, true)
			hover:remove_data()
		end
	end, { silent = true })

	-- action
	vim.keymap.set("n", "<a-cr>", "<cmd>Lspsaga code_action<cr>", { silent = true })
	vim.keymap.set("i", "<a-cr>", "<cmd>Lspsaga code_action<cr>", { silent = true })
	-- Just for neovide
	vim.keymap.set("n", "<M-cr>", "<cmd>Lspsaga code_action<cr>", { silent = true })

	-- signature
	vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true })

	-- rename
	vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

	-- or use command
	vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
	vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
	vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true })
end

return M
