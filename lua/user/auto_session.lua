return {
	"rmagatti/auto-session",
	-- add this to make auto-session lazy
	-- also make sure you don't `require('auto-session')` anywhere
	lazy = false,
	config = function()
		require("auto-session").setup({
			auto_session_enabled = true,
			auto_restore_enabled = true,
			log_level = "error",
			auto_session_suppress_dirs = { "~/.config/", "~/Code/", "~/Work/", "~/oss" },
		})
	end,
}
