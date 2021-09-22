let g:startify_session_dir = '~/.config/nvim/session'

let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']            },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ ]

let g:startify_bookmarks = [
            \ { 'c': '~/Documents/WorkRepo/crypto-ops/mix.exs'},
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.zshrc' },
            \ { 'h': '~/.hammerspoon/private/config.lua'},
            \ '~/Code',
            \ ]

let g:startify_fortune_use_unicode = 1
let g:startify_enable_special = 0
