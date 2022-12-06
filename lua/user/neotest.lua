local status_ok, neotest = pcall(require, "neotest")
if not status_ok then
	return
end

neotest.setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
		}),
		require("neotest-plenary"),
		require("neotest-rust")({
			args = { "--no-capture" },
		}),
		require("neotest-jest")({
			jestCommand = "npm test --",
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
	},
	icons = {
		child_indent = "│",
		child_prefix = "├",
		collapsed = "─",
		expanded = "╮",
		failed = "✖",
		final_child_indent = " ",
		final_child_prefix = "╰",
		non_collapsible = "─",
		passed = "✔",
		running = "🗘",
		running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
		skipped = "ﰸ",
		unknown = "?",
	},

	summary = {
		mappings = {
			next_failed = "]e",
			prev_failed = "[e",
		},
	},

	log_level = vim.log.levels.INFO, -- default is WARN
})

neotest.setup_project(vim.loop.cwd(), {
	adapters = { require("neotest-elixir") },
	default_strategy = "iex",
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
