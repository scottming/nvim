vim.cmd([[
try
  colorscheme dracula_pro_buffy
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])

-- only for onedark
require("onedark").setup({ style = "cool" })
require("onedark").load()
