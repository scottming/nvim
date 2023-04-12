local ts_utils = require("nvim-treesitter.ts_utils")
local parsers = require("nvim-treesitter.parsers")

local M = {}

local function eq_var_range(node_range, current_line_text)
	local _, start_col, _, end_col = unpack(node_range)
	local trimed = current_line_text:match("^(.-)%s*$")
	local start_match = trimed:find("%S")
	local var_start_col = start_match and start_match - 1
	local var_end_col = trimed:find("$") - 1
	return start_col == var_start_col and end_col == var_end_col
end

local function line_not_ends_with_do(current_line_text)
	local trimed = current_line_text:match("^%s*(.-)%s*$")
	return string.sub(trimed, -2) ~= "do"
end

local function line_not_starts_with_at_symbol(current_line_text)
	local trimed = string.match(current_line_text, "^%s*(.-)$")
	return trimed:find("^@") == nil
end

local generate_dbg_action = function(bufnr, range, new_text)
	local start_row, start_col, end_row, end_col = unpack(range)
	return {
		vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { new_text }),
	}
end

M.add_or_remove_dbg = function(context)
	local current_line_range = {
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
		current_line_range.start.line,
		current_line_range.start.line + 1,
		false
	)[1]

	local function generate_remove_dbg(bufnr, range)
		return {
			title = "Remove dbg",
			action = function()
				local new_text = string.gsub(current_line_text, " |> dbg%(%)", "")
				generate_dbg_action(bufnr, range, new_text)
			end,
		}
	end

	local function generate_add_dbg(bufnr, range, new_text, text)
		local title = text and string.format("Add dbg to: %s", text) or "Add dbg"
		return {
			title = title,
			action = function()
				generate_dbg_action(bufnr, range, new_text)
			end,
		}
	end

	local actions = {}

	local function already_has_dbg()
		return current_line_text:find("|> dbg") ~= nil
	end

	if already_has_dbg() then
		local remove_range =
			{ current_line_range.start.line, 0, current_line_range.start.line, string.len(current_line_text) }
		local action = generate_remove_dbg(context.bufnr, remove_range)
		table.insert(actions, action)
		return actions
	end

	-- dbg for remote function calls
	local remote_call_query_scm = [[
    ;; query
      (call
        (dot
          (alias)
          (identifier))
        (arguments)) @alias_call
    ]]
	local local_call_query_scm = [[
    ;; query
    (call
      target: (identifier) @ignore
      (#not-any-of? @ignore 
      ;; def
      "def" "defp" "defdelegate" "defguard" "defguardp" "defmacro" "defmacrop" "defn" "defnp" "defmodule" "defprotocol" "defimpl" "defstruct" "defexception" "defoverridable"
      ;; keywords
      "alias" "case" "cond" "else" "for" "if" "import" "quote" "raise" "receive" "require" "reraise" "super" "throw" "try" "unless" "unquote" "unquote_splicing" "use" "with"
      ;; test
      "doctest" "test" "describe" "assert" "setup")
      ) @local_function_call
    ]]

	local single_var_query_scm = [[
      ;; query
      (identifier) @single_var
  ]]

	local query_str = remote_call_query_scm .. local_call_query_scm .. single_var_query_scm
	-- parse the whole file
	local root_lang_tree = parsers.get_parser(context.bufnr, "elixir")
	local root_node = ts_utils.get_root_for_position(0, 0, root_lang_tree)

	local query = vim.treesitter.query.parse("elixir", query_str)
	for id, node, _ in query:iter_captures(root_node, context.bufnr) do
		local start_row, _, _, _ = node:range()
		if start_row ~= current_line_range.start.line then
			goto continue
		end

		local node_range = { node:range() }
		local text = vim.treesitter.get_node_text(node, context.bufnr)
    local new_text = text .. " |> dbg()"
		local action = generate_add_dbg(context.bufnr, node_range, new_text, text)

		local name = query.captures[id]
		if name == "alias_call" and line_not_starts_with_at_symbol(current_line_text) then
			table.insert(actions, action)
		elseif
			name == "local_function_call"
			and line_not_starts_with_at_symbol(current_line_text)
			and line_not_ends_with_do(current_line_text)
		then
			table.insert(actions, action)
		elseif name == "single_var" and eq_var_range(node_range, current_line_text) then
			table.insert(actions, action)
		end

		::continue::
	end

	return actions
end

return M
