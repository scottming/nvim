local status_ok, dap = pcall(require, "dap")
if not status_ok then
	return
end

-- lua osv
dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

-- elixir
dap.configurations.elixir = {
	{
		type = "mix_task",
		name = "mix test",
		task = "test",
		taskArgs = { "--trace" },
		request = "launch",
		startApps = true, -- for Phoenix projects
		projectDir = "${workspaceFolder}",
		requireFiles = {
			"test/**/test_helper.exs",
			"test/**/*_test.exs",
		},
	},
}

dap.adapters.mix_task = {
	type = "executable",
	command = vim.fn.getenv("HOME") .. "/.elixir-ls/release/debugger.sh", -- debugger.bat for windows
	args = {},
}
