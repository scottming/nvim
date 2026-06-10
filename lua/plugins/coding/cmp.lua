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
					suggestion = { auto_trigger = true },
					panel = { keymap = { open = "<M-S-CR>" } },
				})
			end,
		},
	},
	event = { "InsertEnter", "CmdlineEnter" },
}

local source_labels = {
	nvim_lsp = "[LSP]",
	luasnip = "[Snippet]",
	buffer = "[Buffer]",
	path = "[Path]",
}

local function format_entry(kind_icons)
	return function(entry, item)
		item.kind = kind_icons[item.kind] or item.kind
		item.menu = source_labels[entry.source.name]
		return item
	end
end

local function tab_select(cmp, luasnip)
	return function(fallback)
		local suggestion = require("copilot.suggestion")
		if suggestion.is_visible() then
			suggestion.accept()
		elseif cmp.visible() then
			cmp.confirm({ select = true })
		elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		else
			fallback()
		end
	end
end

local function shift_tab_select(luasnip)
	return function(fallback)
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end
end

local function build_mappings(cmp, luasnip)
	return {
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-y>"] = { i = cmp.mapping.confirm({ select = true }) },
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(tab_select(cmp, luasnip), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(shift_tab_select(luasnip), { "i", "s" }),
	}
end

local function setup_insert(cmp, compare, luasnip, kind_icons)
	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = build_mappings(cmp, luasnip),
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = format_entry(kind_icons),
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
end

local function setup_cmdline(cmp)
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = { { name = "cmdline" } },
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	})
end

function M.config()
	local cmp = require("cmp")
	local compare = require("cmp.config.compare")
	local luasnip = require("luasnip")
	local kind_icons = require("utils.styles").lsp_kind_icons("nerdfonts")

	require("luasnip/loaders/from_vscode").lazy_load()
	setup_insert(cmp, compare, luasnip, kind_icons)
	setup_cmdline(cmp)
end

return M
