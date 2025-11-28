set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

let g:loaded_node_provider=1
source ~/.vimrc
"source ~/.config/nvim/coc.vim
" source ~/.config/nvim/lua/init.lua 

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Config Section

" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if (has('termguicolors'))
  set termguicolors
endif

" let g:coc_global_extensions = ['coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-angular', 'coc-eslint', 'coc-highlight', 'coc-elixir' ]

" Highlight Yank
let g:highlightedyank_highlight_duration = 500

" Theme
syntax enable
syntax on

" let g:oceanic_next_terminal_bold = 1
" let g:oceanic_next_terminal_italic = 1
" let g:material_terminal_italics = 1
" let g:material_theme_style = 'darker-community'
" colorscheme material
" colorscheme minimalist
" colorscheme purpura 

" colorscheme gruvbox
" colorscheme molokai
" colorscheme nightfly
" colorscheme OceanicNext


" Make background transparent
"hi Normal guibg=NONE ctermbg=NONE

"" == NERDTree configuration == 
" let g:NERDTreeShowHidden = 1
" let g:NERDTreeMinimalUI = 1
" let g:NERDTreeIgnore = []
" let g:NERDTreeStatusline = ''
" let g:NERDTreeChDirMode = 2
" " Automaticaly close nvim if NERDTree is only thing left open
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" " Toggle
" nnoremap <silent> <C-b> :NERDTreeToggle<CR>



" Setup vim-notes Options
filetype plugin on
