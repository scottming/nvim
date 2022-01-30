local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	-- one of "all", "maintained" (parsers with maintainers), or a list of languages
	ensure_installed = { "eex", "heex", "elixir", "lua" },
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "haskell" }, -- List of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml", "elixir" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})
