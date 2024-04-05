return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- calling `setup` is optional for customization
		require("fzf-lua").setup({ "telescope" })
	end,
	-- commit = "f430c5b3b1d531cff8d011474461ea3090e932e2",
  commit = "2ba4a51eb36febd864735b7b25ac2bd1d1f7cf08",
	event = "VeryLazy",
}
