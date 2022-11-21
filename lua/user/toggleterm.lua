local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end

local ttt = require("toggleterm.terminal")

vim.g["test#custom_strategies"] = {
	tterm = function(cmd)
		toggleterm.exec(cmd)
	end,

	tterm_close = function(cmd)
		local term_id = 0
		toggleterm.exec(cmd, term_id)
		ttt.get_or_create_term(term_id):close()
	end,
}

vim.g["test#strategy"] = "tterm"

-- for elixir iex test

vim.api.nvim_create_user_command("TestIexStart", function()
  -- Please add these lines to the `.iex.exs`
  --[[ Code.eval_file("~/.test_iex/lib/test_iex.ex") ]]
  --[[ System.get_env("MIX_ENV") && TestIex.start() ]]
	toggleterm.exec('MIX_ENV=test iex --no-pry -S mix', 1)
	ttt.get_or_create_term(1):close()
end, {})

vim.api.nvim_create_user_command("TestIex", function()
  local line_col = vim.api.nvim_win_get_cursor(0)[1]
  local path = vim.fn.expand("%")
  local test_command = string.format("TestIex.test(%q, %q)", path, line_col)
  if (vim.endswith(path, ".exs"))
  then
    toggleterm.exec(test_command, 1)
    vim.g.last_test_iex_command = test_command
  else
    toggleterm.exec(vim.g.last_test_iex_command, 1)
  end
end, {})

