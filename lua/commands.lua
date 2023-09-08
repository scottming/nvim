-- for lspsaga
-- vim.cmd("highlight! FinderBorder guifg=#9F70A9 guibg=none")
-- vim.cmd("highlight! FinderPreviewBorder guifg=#9F70A9 guibg=none")
-- vim.cmd("highlight! DefinitionBorder guifg=#9F70A9 guibg=none")
-- vim.cmd("highlight! HoverBorder guifg=#9F70A9 guibg=none")
-- vim.cmd("highlight! RenameBorder guifg=#9F70A9 guibg=none")

-- for indent-blankline

-- #848b98
vim.cmd([[highlight IndentBlanklineContextChar guifg=#7a818e gui=nocombine]])
vim.cmd([[highlight IndentBlanklineContextStart guifg=#7a818e gui=nocombine]])

-- vim.api.nvim_set_hl(0, "LeapMatch", { bold = true, bg = "#ff007c" })
-- vim.api.nvim_set_hl(0, "LeapLabelPrimary", { bold = true, fg = "#ff007c" })
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
