local M = {}

local SPECIAL_UMBRELLA = {
	lexical = true,
	kyc = true,
	ops = true,
	messen = true,
}

function M.is_special_umbrella(git_root)
	return SPECIAL_UMBRELLA[vim.fn.fnamemodify(git_root, ":t")] == true
end

return M
