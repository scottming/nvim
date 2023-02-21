local status_ok, saga = pcall(require, "lspsaga-mini")
if not status_ok then
	return
end

-- change the lsp symbol kind

-- use default config
saga.setup({})
