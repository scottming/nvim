local M = {}

function M.resolve_root(bufnr)
	bufnr = bufnr or 0
	local git_root = vim.fs.root(bufnr, ".git")
	if git_root
		and vim.fn.filereadable(git_root .. "/mix.exs") == 1
		and vim.fn.isdirectory(git_root .. "/apps") == 1
	then
		return git_root
	end
	return vim.fs.root(bufnr, { "mix.exs", ".git" })
end

return M
