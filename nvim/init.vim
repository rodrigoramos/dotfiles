set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

source ~/.config/nvim/coc.vim


call plug#begin("~/.vim/plugged")
  " Plugin Section
  
  " Theme
  "Plug 'dikiaap/minimalist'
  Plug 'arcticicestudio/nord-vim'
  Plug 'kaicataldo/material.vim', { 'branch': 'main' }

  " File Explorer
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'

  " File Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  
  " Language Client
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Typescript highlighting
  "Plug 'leafgarland/typescript-vim'
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'

  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'romgrk/barbar.nvim'

  Plug 'machakann/vim-highlightedyank'

  Plug 'tpope/vim-commentary'

call plug#end()

let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-angular', 'coc-tslint', 'coc-omnisharp']
" Config Section

" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if (has('termguicolors'))
  set termguicolors
endif

" Highlight Yank
let g:highlightedyank_highlight_duration = 500

let g:material_terminal_italics = 1
let g:material_theme_style = 'darker'
colorscheme material

" Theme
syntax on
syntax enable

" Make background transparent
"hi Normal guibg=NONE ctermbg=NONE

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let g:NERDTreeChDirMode = 2
" Automaticaly close nvim if NERDTree is only thing left open
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

 " use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" nnoremap <C-k> :tabprevious<CR>
" nnoremap <C-j> :tabnext<CR>

" Move to previous/next
nnoremap <silent>    <C-k> :BufferPrevious<CR>
nnoremap <silent>    <C-j> :BufferNext<CR>

" Goto buffer in position...
nnoremap <silent>    <A-1> :BufferGoto 1<CR>
nnoremap <silent>    <A-2> :BufferGoto 2<CR>
nnoremap <silent>    <A-3> :BufferGoto 3<CR>
nnoremap <silent>    <A-4> :BufferGoto 4<CR>
nnoremap <silent>    <A-5> :BufferGoto 5<CR>
nnoremap <silent>    <A-6> :BufferGoto 6<CR>
nnoremap <silent>    <A-7> :BufferGoto 7<CR>
nnoremap <silent>    <A-8> :BufferGoto 8<CR>
nnoremap <silent>    <A-9> :BufferLast<CR>

" Close buffer
nnoremap <silent>    <C-w> :BufferClose<CR>

nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

