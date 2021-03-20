set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

set number relativenumber       " set relative number with absolute line number on selected line
set nobackup
set nowritebackup

set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)

set nocompatible                " no compatibility legacy v1
syntax enable
set encoding=utf-8

set background=dark
colorscheme gruvbox

set clipboard=unnamedplus

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set guitablabel=%N/\ %t\ %M
