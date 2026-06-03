local function lazy_plugin_root(name)
	local paths = vim.api.nvim_get_runtime_file("lua/" .. name .. "/init.lua", true)
	if paths[1] then
		return vim.fs.dirname(paths[1])
	end
end

local library = {
	[vim.fn.expand("$VIMRUNTIME/lua")] = true,
	[vim.fn.stdpath("config") .. "/lua"] = true,
}

for _, name in ipairs({ "neotest", "nvim-treesitter" }) do
	local root = lazy_plugin_root(name)
	if root then
		library[root] = true
	end
end

return {
	settings = {
		Lua = {
			hint = { enable = true },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = library,
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			format = {
				enable = false,
			},
		},
	},
}
