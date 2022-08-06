local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
	return
end

-- change the lsp symbol kind

-- use default config
saga.init_lsp_saga()
