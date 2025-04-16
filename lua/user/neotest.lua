local M = {
	"nvim-neotest/neotest",
	version = "5.8.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/nvim-nio",
		-- Adpters
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-plenary",
		"jfpedroza/neotest-elixir",
		"rouge8/neotest-rust",
	},
	event = "LspAttach",
}

function M.config()
	local neotest = require("neotest")

	neotest.setup({
		adapters = {
			require("neotest-python")({
				dap = { justMyCode = false },
				runner = "pytest",
			}),
			require("neotest-elixir")({
				iex_shell_direction = "float",
			}),
			require("neotest-plenary").setup({
				-- "../utils/test_init.lua",
				min_init = "~/.config/nvim/lua/utils/test_init.lua",
			}),
			require("neotest-rust")({
				args = { "--no-capture" },
			}),
		},
		summary = {
			mappings = {
				next_failed = "]e",
				prev_failed = "[e",
			},
		},
		watch = {
			enabled = true,
			symbol_queries = {},
		},
		output = {
			short = true,
		},
		output_panel = {
			enabled = false,
		},
		quickfix = {
			enabled = false,
		},

		log_level = vim.log.levels.INFO, -- default is WARN
	})

	local group = vim.api.nvim_create_augroup("NeotestConfig", {})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "neotest-output",
		group = group,
		callback = function(opts)
			vim.keymap.set("n", "q", function()
				pcall(vim.api.nvim_win_close, 0, true)
			end, {
				buffer = opts.buf,
			})
		end,
	})

	-- for vim test
	vim.g["test#strategy"] = "neovim"
	-- vim.g["test#neovim#start_normal"] = 1

	-- for ablish highlight integration
	vim.g["traces_abolish_integration"] = 1
end

return M
