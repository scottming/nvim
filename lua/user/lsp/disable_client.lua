local M = {}

M.disable_elixirls_in = function(special_project)
	-- Check if the dirname matches the special project directory
	local function is_special_project()
		local special_dir_stat = vim.loop.fs_stat(special_project)
		local dirname_stat = vim.loop.fs_stat(vim.loop.cwd())

		return special_project and dirname_stat.dev == special_dir_stat.dev and dirname_stat.ino == special_dir_stat.ino
	end

	if is_special_project() then
		-- Stop elixirls client if it's active
		for _, client in ipairs(vim.lsp.get_active_clients()) do
			if client.name == "elixirls" then
				vim.lsp.stop_client(client.id)
				print("Stop elixirls successful")
			end
		end
	else
		print("not the same")
	end
end

return M
