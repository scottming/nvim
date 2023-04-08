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
	local function line_ends_with_do()
		local line = line_text()
		local trimed = line:match("^%s*(.-)%s*$")
		return string.sub(trimed, -2) == "do"
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
		if name == "local_function_call" and start_row == zero_based_range.start.line and not line_ends_with_do() then
			if already_has_dbg() then
				local action = generate_remove_dbg(context.bufnr, start_row, 0, end_row)
				table.insert(actions, action)
			else
				local text = vim.treesitter.get_node_text(node, context.bufnr)
				local new_text = text .. " |> dbg()"
				local action = generate_add_dbg(context.bufnr, start_row, start_col, end_row, end_col, new_text)
				table.insert(actions, action)
			end
		end
	end

	return actions
end

return M
