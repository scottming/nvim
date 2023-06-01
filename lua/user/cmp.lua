local M = {
	"hrsh7th/nvim-cmp",
	commit = "e28fb7a730b1bd425fdddfdbd3d36bb84bd77611",
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
		},
		{
			"hrsh7th/cmp-buffer",
			commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
		},
		{
			"hrsh7th/cmp-path",
			commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
		},
		{
			"hrsh7th/cmp-cmdline",
			commit = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063",
		},
		{
			"saadparwaiz1/cmp_luasnip",
			commit = "18095520391186d634a0045dacaa346291096566",
		},
		{
			"L3MON4D3/LuaSnip",
			commit = "a83e4b1ba7edc6fecdad09e39753a7d5eee1d01c",
			event = "InsertEnter",
			dependencies = {
				"rafamadriz/friendly-snippets",
				commit = "a6f7a1609addb4e57daa6bedc300f77f8d225ab7",
			},
		},
		{
			"hrsh7th/cmp-nvim-lua",
			commit = "f3491638d123cfd2c8048aefaf66d246ff250ca6",
		},
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
					suggestion = {
						auto_trigger = true,
					},
					panel = {
						keymap = {
							open = "<M-S-CR>",
						},
					},
				})
			end,
		},
	},
	event = {
		"InsertEnter",
		"CmdlineEnter",
	},
}

function M.config()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	require("luasnip/loaders/from_vscode").lazy_load()

	local check_backspace = function()
		local col = vim.fn.col(".") - 1
		return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
	end

	--   פּ ﯟ   some other good icons
	local kind_icons = {
		Text = "",
		Method = "ƒ",
		Function = "",
		Constructor = "",
		Field = "",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "",
		Event = "",
		Operator = "",
		TypeParameter = "",
	}
	-- find more here: https://www.nerdfonts.com/cheat-sheet

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-y>"] = {
				i = cmp.mapping.confirm({ select = true }),
			},
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				-- accept copilot first
				local suggestion = require("copilot.suggestion")
				if suggestion.is_visible() then
					suggestion.accept()
				elseif cmp.visible() then
					cmp.confirm({ select = true })
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif check_backspace() then
					fallback()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				-- Kind icons
				vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
				vim_item.menu = ({
					nvim_lsp = "[LSP]",
					luasnip = "[Snippet]",
					buffer = "[Buffer]",
					path = "[Path]",
				})[entry.source.name]
				return vim_item
			end,
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
		},
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		experimental = {
			ghost_text = false,
			native_menu = false,
		},
	})
end

return M
