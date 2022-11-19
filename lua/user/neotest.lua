local status_ok, neotest = pcall(require, "neotest")
if not status_ok then
	return
end

require("neotest.logging"):set_level("debug")

neotest.setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
		}),
		require("neotest-plenary"),
		require("neotest-rust")({
			args = { "--no-capture" },
		}),
		require("neotest-elixir")({
			-- Other formatters to pass to the test command as the formatters are overridden
			-- Can be a function to return a dynamic value.
			-- Default: {"ExUnit.CLIFormatter"}
			extra_formatters = { "ExUnit.CLIFormatter", "ExUnitNotifier" },
			-- Extra arguments to pass to mix test
			-- Can be a function that receives the position, to return a dynamic value
			-- Default: {}
			args = { "--trace" },
			-- Delays writes so that results are updated at most every given milliseconds
			-- Decreasing this number improves snappiness at the cost of performance
			-- Can be a function to return a dynamic value.
			-- Default: 1000
			write_delay = 1000,
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
