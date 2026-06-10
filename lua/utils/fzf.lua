local elixir_root = require("utils.lsp.elixir_root")

local M = {}

local files_opts = {
	fzf_opts = { ["--layout"] = "default" },
	winopts = { height = 0.5, preview = { hidden = "hidden" } },
}

function M.files(overrides)
	local opts = vim.tbl_deep_extend("force", {}, files_opts, overrides or {})
	local root = elixir_root.resolve_root()
	if root ~= vim.fs.root(0, "mix.exs") then
		opts.cwd = root
	end
	require("fzf-lua").files(opts)
end

return M
