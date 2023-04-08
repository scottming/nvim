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

	local current_line_text = vim.api.nvim_buf_get_lines(
		context.bufnr,
		zero_based_range.start.line,
		zero_based_range.start.line + 1,
		false
	)[1]

	local function generate_remove_dbg(bufnr, start_row, start_col, end_row, _)
		return {
			title = "Remove dbg",
			action = function()
				local new_text = string.gsub(current_line_text, " |> dbg%(%)", "")
				generate_dbg_action(bufnr, start_row, start_col, end_row, string.len(current_line_text), new_text)
			end,
		}
	end

	local function generate_add_dbg(bufnr, start_row, start_col, end_row, end_col, new_text, text)
		local title = text and string.format("Add dbg to: %s", text) or "Add dbg"
		return {
			title = title,
			action = function()
				generate_dbg_action(bufnr, start_row, start_col, end_row, end_col, new_text)
			end,
		}
	end

	-- parse the whole file
	local root_lang_tree = parsers.get_parser(context.bufnr, "elixir")
	local root_node = ts_utils.get_root_for_position(0, 0, root_lang_tree)
	local actions = {}
	local function already_has_dbg()
		return current_line_text:find("|> dbg") ~= nil
	end

	if already_has_dbg() then
		local action = generate_remove_dbg(context.bufnr, zero_based_range.start.line, 0, zero_based_range.start.line)
		table.insert(actions, action)
		return actions
	end

	-- dbg for remote function calls
	local remote_call_query_scm = [[
      (call
        (dot
          (alias)
          (identifier))
        (arguments)) @alias_call
    ]]
	local query = vim.treesitter.query.parse("elixir", remote_call_query_scm)
	for _, node, _ in query:iter_captures(root_node, context.bufnr) do
		local text = vim.treesitter.get_node_text(node, context.bufnr)
		local start_row, start_col, end_row, end_col = node:range()

		if start_row == zero_based_range.start.line then
			local new_text = text .. " |> dbg()"
			local action = generate_add_dbg(context.bufnr, start_row, start_col, end_row, end_col, new_text, text)
			table.insert(actions, action)
		end
	end

	-- dbg for local function calls
	-- we should filter out the build-in functions, like `def|defp`
	local function line_not_ends_with_do(node)
		local start_row, _, _, _ = node:range()
		local trimed = current_line_text:match("^%s*(.-)%s*$")
		return zero_based_range.start.line == start_row and string.sub(trimed, -2) ~= "do"
	end

	local local_call_query_scm = [[
    (call
      target: (identifier) @ignore
      (#not-match? @ignore "^(def|defp|defdelegate|defguard|defguardp|defmacro|defmacrop|defn|defnp|defmodule|defprotocol|defimpl|defstruct|defexception|defoverridable|alias|case|cond|else|for|if|import|quote|raise|receive|require|reraise|super|throw|try|unless|unquote|unquote_splicing|use|with|doctest|test|describe|assert)$")) @local_function_call
    ]]

	local local_func_query = vim.treesitter.query.parse("elixir", local_call_query_scm)
	for id, node, _ in local_func_query:iter_captures(root_node, context.bufnr) do
		local name = local_func_query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()
		if name == "local_function_call" and line_not_ends_with_do(node) then
			local text = vim.treesitter.get_node_text(node, context.bufnr)
			local new_text = text .. " |> dbg()"
			local action = generate_add_dbg(context.bufnr, start_row, start_col, end_row, end_col, new_text, text)
			table.insert(actions, action)
		end
	end

	-- dbg for the single variable at a line
	local single_var_query_scm = [[
    (identifier) @single_var
  ]]

	local function eq_var_range(node)
		local start_row, start_col, _, end_col = node:range()
		local trimed = current_line_text:match("^(.-)%s*$")
		local start_match = trimed:find("%S")
		local var_start_col = start_match and start_match - 1
		local var_end_col = trimed:find("$") - 1

		return start_row == zero_based_range.start.line and start_col == var_start_col and end_col == var_end_col
	end

	local single_var_query = vim.treesitter.query.parse("elixir", single_var_query_scm)
	for id, node, _ in single_var_query:iter_captures(root_node, context.bufnr) do
		local name = single_var_query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()
		if name == "single_var" and eq_var_range(node) then
			local text = vim.treesitter.get_node_text(node, context.bufnr)
			local new_text = text .. " |> dbg()"
			local action = generate_add_dbg(context.bufnr, start_row, start_col, end_row, end_col, new_text)
			table.insert(actions, action)
		end
	end

	return actions
end

return M
