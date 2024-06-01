function _G.set_iex_strategy_after_delay()
	vim.defer_fn(function()
		if not _G.neotest_strategy_manually then
			require("utils").set_iex_strategy()
		end
	end, 100)
end

vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  augroup _elixir
    autocmd!
    autocmd FileType elixir setlocal indentkeys+=0=end
    autocmd FileType eelixir setlocal indentkeys+=0=end
    autocmd FileType elixir setlocal indentkeys-=0{
    autocmd BufReadPost *.exs lua set_iex_strategy_after_delay()
    autocmd DirChanged * lua if vim.bo.filetype == 'elixir' then set_iex_strategy_after_delay() end
    autocmd BufReadPost mix.exs lua vim.lsp.codelens.refresh()
  augroup end
]])

---Highlight yanked text
local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

au("TextYankPost", {
	group = ag("yank_highlight", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

local luasnip = require("luasnip")

local unlinkgrp = vim.api.nvim_create_augroup("UnlinkSnippetOnModeChange", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
	group = unlinkgrp,
	pattern = { "s:n", "i:*" },
	desc = "Forget the current snippet when leaving the insert mode",
	callback = function(evt)
		if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
			luasnip.unlink_current()
		end
	end,
})

-- Autoformat
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- augroup end
