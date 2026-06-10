local api = vim.api
local create = api.nvim_create_autocmd
local group = api.nvim_create_augroup

-- elixir / neotest
function _G.set_iex_strategy_after_delay()
	vim.defer_fn(function()
		if not _G.neotest_strategy_manually then
			require("utils").set_iex_strategy()
		end
	end, 100)
end

local function setup_filetype_autocmds()
	local aug = group("_general_settings", { clear = true })
	create("FileType", {
		group = aug,
		pattern = { "qf", "help", "man", "lspinfo" },
		callback = function(event)
			api.nvim_buf_set_keymap(event.buf, "n", "q", ":close<CR>", { silent = true })
		end,
	})
	create("BufWinEnter", {
		group = aug,
		callback = function()
			vim.opt.formatoptions:remove("cro")
		end,
	})
	create("FileType", {
		group = aug,
		pattern = "qf",
		callback = function()
			vim.opt_local.buflisted = false
		end,
	})

	local git = group("_git", { clear = true })
	create("FileType", {
		group = git,
		pattern = "gitcommit",
		callback = function()
			vim.opt_local.wrap = true
			vim.opt_local.spell = true
		end,
	})

	local markdown = group("_markdown", { clear = true })
	create("FileType", {
		group = markdown,
		pattern = "markdown",
		callback = function()
			vim.opt_local.wrap = true
			vim.opt_local.spell = true
		end,
	})
end

local function setup_ui_autocmds()
	create("VimResized", {
		group = group("_auto_resize", { clear = true }),
		callback = function()
			vim.cmd("tabdo wincmd =")
		end,
	})

	create("User", {
		group = group("_alpha", { clear = true }),
		pattern = "AlphaReady",
		callback = function()
			vim.opt.showtabline = 0
			create("BufUnload", {
				buffer = 0,
				callback = function()
					vim.opt.showtabline = 2
				end,
			})
		end,
	})
end

local function setup_elixir_autocmds()
	local aug = group("_elixir", { clear = true })
	create("FileType", {
		group = aug,
		pattern = { "elixir", "eelixir" },
		callback = function()
			vim.opt_local.indentkeys:append("0=end")
			vim.opt_local.indentkeys:remove("0{")
		end,
	})
	create("BufReadPost", {
		group = aug,
		pattern = "*.exs",
		callback = function()
			set_iex_strategy_after_delay()
		end,
	})
	create("DirChanged", {
		group = aug,
		callback = function()
			if vim.bo.filetype == "elixir" then
				set_iex_strategy_after_delay()
			end
		end,
	})
	create("BufReadPost", {
		group = aug,
		pattern = "mix.exs",
		callback = function()
			vim.lsp.codelens.refresh()
		end,
	})
end

local function setup_editor_autocmds()
	create("TextYankPost", {
		group = group("yank_highlight", { clear = true }),
		pattern = "*",
		callback = function()
			vim.hl.on_yank({ higroup = "IncSearch", timeout = 300 })
		end,
	})

	local luasnip = require("luasnip")
	create("ModeChanged", {
		group = group("UnlinkSnippetOnModeChange", { clear = true }),
		pattern = { "s:n", "i:*" },
		desc = "Forget the current snippet when leaving the insert mode",
		callback = function(event)
			if luasnip.session and luasnip.session.current_nodes[event.buf] and not luasnip.session.jump_active then
				luasnip.unlink_current()
			end
		end,
	})
end

local function setup_lsp_commands()
	api.nvim_create_user_command("LspClients", function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients == 0 then
			vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
			return
		end
		local lines = { "LSP clients for: " .. vim.fn.expand("%:p"), "" }
		for _, client in ipairs(clients) do
			table.insert(lines, string.format("  %-20s id=%d  root=%s", client.name, client.id, client.root_dir or "(none)"))
		end
		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
	end, { desc = "Show LSP clients attached to current buffer" })
end

setup_filetype_autocmds()
setup_ui_autocmds()
setup_elixir_autocmds()
setup_editor_autocmds()
setup_lsp_commands()
