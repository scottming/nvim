local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		{
			"L3MON4D3/LuaSnip",
			event = "InsertEnter",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
		},
		"hrsh7th/cmp-nvim-lua",
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
	local compare = require("cmp.config.compare")
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
			["<Up>"] = cmp.mapping.select_prev_item(),
			["<Down>"] = cmp.mapping.select_next_item(),
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
		sorting = {
			priority_weight = 2,
			comparators = {
				compare.offset,
				compare.exact,
				compare.score,
				compare.recently_used,
				compare.sort_text,
				compare.kind,
				compare.length,
				compare.order,
			},
		},
	})

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = { { name = "cmdline" } },
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	})
end

return M
