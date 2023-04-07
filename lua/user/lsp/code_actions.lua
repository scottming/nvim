local ts_utils = require("nvim-treesitter.ts_utils")
local parsers = require("nvim-treesitter.parsers")

local M = {}

local generate_dbg_action = function(bufnr, start_row, start_col, end_row, end_col, new_text)
	return {
		vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { new_text }),
	}
end

M.add_dbg = function(context)
	local context_row = context.range.row
	local root_lang_tree = parsers.get_parser(context.bufnr, "elixir")
	local root_node = ts_utils.get_root_for_position(0, 0, root_lang_tree)

	local alias_call_query = [[
    (call
      (dot
        (alias) 
        (identifier))
      (arguments)) @alias_call
  ]]

	local function line_text()
		return vim.api.nvim_buf_get_lines(context.bufnr, context_row - 1, context_row, false)[1]
	end

	local function already_has_dbg()
		return line_text():find("|> dbg") ~= nil
	end

	local actions = {}
	local query = vim.treesitter.query.parse("elixir", alias_call_query)
	for _, node, _ in query:iter_captures(root_node, context.bufnr) do
		local text = vim.treesitter.get_node_text(node, context.bufnr)
		local start_row, start_col, end_row, end_col = node:range()

		if start_row == (context_row - 1) then
			if already_has_dbg() then
				local action = {
					title = "Remove dbg",
					action = function()
						local new_text = string.gsub(line_text(), " |> dbg%(%)", "")
						print(new_text, "new_text")
						generate_dbg_action(context.bufnr, start_row, 0, end_row, string.len(line_text()), new_text)
					end,
				}
				table.insert(actions, action)
			else
				local action = {
					title = "Add dbg",
					action = function()
						local new_text = text .. " |> dbg()"
						generate_dbg_action(context.bufnr, start_row, start_col, end_row, end_col, new_text)
					end,
				}
				table.insert(actions, action)
			end
		end
	end

	return actions
end

return M
