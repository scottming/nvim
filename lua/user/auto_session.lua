return {
	"rmagatti/auto-session",
	-- add this to make auto-session lazy
	-- also make sure you don't `require('auto-session')` anywhere
	lazy = false,
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/.config/", "~/Code/", "~/Work/", "~/oss" },
		})
	end,
}
