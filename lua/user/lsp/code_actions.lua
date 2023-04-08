local ts_utils = require("nvim-treesitter.ts_utils")
local parsers = require("nvim-treesitter.parsers")

local M = {}

local generate_dbg_action = function(bufnr, start_row, start_col, end_row, end_col, new_text)
	return {
		vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { new_text }),
	}
end

M.add_or_remove_dbg = function(context)
	local zero_based_range = {
		start = {
			line = context.range.row - 1,
			character = context.range.col - 1,
		},
		["end"] = {
			line = context.range.end_row - 1,
			character = context.range.end_col - 1,
		},
	}

	local function line_text()
		return vim.api.nvim_buf_get_lines(
			context.bufnr,
			zero_based_range.start.line,
			zero_based_range.start.line + 1,
			false
		)[1]
	end

	local function already_has_dbg()
		return line_text():find("|> dbg") ~= nil
	end

	local function generate_remove_dbg(bufnr, start_row, start_col, end_row, _)
		return {
			title = "Remove dbg",
			action = function()
				local new_text = string.gsub(line_text(), " |> dbg%(%)", "")
				generate_dbg_action(bufnr, start_row, start_col, end_row, string.len(line_text()), new_text)
			end,
		}
	end

	local function generate_add_dbg(bufnr, start_row, start_col, end_row, end_col, new_text)
		return {
			title = "Add dbg",
			action = function()
				generate_dbg_action(bufnr, start_row, start_col, end_row, end_col, new_text)
			end,
		}
	end

	-- parse the whole file
	local root_lang_tree = parsers.get_parser(context.bufnr, "elixir")
	local root_node = ts_utils.get_root_for_position(0, 0, root_lang_tree)
	local actions = {}
	-- dbg for remote function calls
	local alias_call_query = [[
      (call
        (dot
          (alias) 
          (identifier))
        (arguments)) @alias_call
    ]]
	local query = vim.treesitter.query.parse("elixir", alias_call_query)
	for _, node, _ in query:iter_captures(root_node, context.bufnr) do
		local text = vim.treesitter.get_node_text(node, context.bufnr)
		local start_row, start_col, end_row, end_col = node:range()

		if start_row == zero_based_range.start.line then
			if already_has_dbg() then
				local action = generate_remove_dbg(context.bufnr, start_row, 0, end_row)
				table.insert(actions, action)
			else
				local new_text = text .. " |> dbg()"
				local action = generate_add_dbg(context.bufnr, start_row, start_col, end_row, end_col, new_text)
				table.insert(actions, action)
			end
		end
	end

	-- dbg for local function calls
	return actions
end

return M
