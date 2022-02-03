vim.cmd [[
try
  colorscheme dracula_pro_morbius
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
