set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

source ~/.vimrc
source ~/.config/nvim/coc.vim

call plug#begin("~/.vim/plugged")
  "Plugin Section
  
  " Themes
  " Plug 'dikiaap/minimalist'
  " Plug 'kaicataldo/material.vim', { 'branch': 'main' }
  " Plug 'artanikin/vim-synthwave84'
  " Plug 'yassinebridi/vim-purpura'
  " Plug 'flazz/vim-colorschemes'

  "" File Explorer
  " NERD Tree
  " Plug 'scrooloose/nerdtree'
  "Plug 'ryanoasis/vim-devicons'
  
 " Nvim Tree
  Plug 'nvim-tree/nvim-web-devicons' 
  Plug 'nvim-tree/nvim-tree.lua'

  " File Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  
  " Language Client
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
  " Plug 'David-Kunz/jester'
  " Plug 'sheerun/vim-polyglot'

  " Debug
  "Plug 'puremourning/vimspector'

  "Plug 'vim-test/vim-test'

  " Typescript highlighting
   Plug 'leafgarland/typescript-vim'
  " Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'

  " Barra Superior
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'romgrk/barbar.nvim'


  " Plugins Angular
  " Plug 'softoika/ngswitcher.vim'
  " Plug '~/git/fork/ngswitcher.vim'
  Plug 'rodrigoramos/ngswitcher.vim'

  " Vim Enhancements
  Plug 'machakann/vim-highlightedyank'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'gko/vim-coloresque' " Show hexa colors 

  " Notes!
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-notes'

  " Table
  Plug 'dhruvasagar/vim-table-mode'

call plug#end()

function! VimspectorJestDebugOnCursor(cmd)
    let testName = matchlist(a:cmd, '\v -t ''(.*)''')[1]
    call vimspector#LaunchWithSettings( #{ configuration: 'jest', TestName: testName } )
endfunction

let g:test#javascript#runner = 'jest'
let g:test#custom_strategies = {
  \ 'jest-on-cursor': function('VimspectorJestDebugOnCursor')
  \ }

nnoremap <leader>rd "ty:TestNearest -strategy=jest-on-cursor<CR>
nnoremap <leader>rr :TestNearest<CR>
nnoremap <leader>rc :call vimspector#Reset()<CR>

" Config Section

" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if (has('termguicolors'))
  set termguicolors
endif

let g:coc_global_extensions = ['coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-angular', 'coc-eslint', 'coc-highlight' ]

" Highlight Yank
let g:highlightedyank_highlight_duration = 500

" let g:material_terminal_italics = 1
" let g:material_theme_style = 'darker-community'
" colorscheme material
" colorscheme minimalist
" colorscheme purpura 

colorscheme gruvbox
colorscheme molokai


" Theme
syntax on
syntax enable

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


"" == NvimTree Configuration == 
nnoremap <silent> <C-b> :NvimTreeFindFileToggle<CR>


" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


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
nnoremap <silent>    <A-q> :BufferClose<CR>
nnoremap <silent>    <S-w> :BufferClose!<CR>

" List Buffers
nnoremap <silent>    <A-p> :Buffers<CR>
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

let $FZF_DEFAULT_COMMAND = 'rg --files . !.git !node_modules'


" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git', '!node_modules'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Custom options for Denite
"   split                       - Use floating window for Denite
"   start_filter                - Start filtering on default
"   auto_resize                 - Auto resize the Denite window height automatically.
"   source_names                - Use short long names if multiple sources
"   prompt                      - Customize denite prompt
"   highlight_matched_char      - Matched characters highlight
"   highlight_matched_range     - matched range highlight
"   highlight_window_background - Change background group in floating window
"   highlight_filter_background - Change background group in floating filter window
"   winrow                      - Set Denite filter window to top
"   vertical_preview            - Open the preview window vertically

let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

" === Denite shorcuts === "
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
" nmap ; :Denite buffer -split=floating -winrow=1 -statusline<CR>
"nmap <leader>t :DeniteProjectDir file/rec -split=floating<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty -split=floating<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:. -split=floating<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-h>         - Open currently selected file in a horizontal split
" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction


" COC Restore PUM Navigatino with TAB
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Setup vim-notes Options
filetype plugin on
let g:notes_directories = ['~/Documents/l3/notes', '~/Documents/notes']


" NgSwitcher Config
nnoremap <Leader>st :<C-u>NgSwitchTS<CR>
nnoremap <Leader>sc :<C-u>NgSwitchCSS<CR>
nnoremap <Leader>sh :<C-u>NgSwitchHTML<CR>
nnoremap <Leader>ss :<C-u>NgSwitchSpec<CR>

" with horizontal split
nnoremap <leader>hu :<C-u>SNgSwitchTS<CR>
nnoremap <leader>hi :<C-u>SNgSwitchCSS<CR>
nnoremap <leader>ho :<C-u>SNgSwitchHTML<CR>
nnoremap <leader>hp :<C-u>SNgSwitchSpec<CR>

" with vertical split
nnoremap <leader>vu :<C-u>VNgSwitchTS<CR>
nnoremap <leader>vi :<C-u>VNgSwitchCSS<CR>
nnoremap <leader>vo :<C-u>VNgSwitchHTML<CR>
nnoremap <leader>vp :<C-u>VNgSwitchSpec<CR>

"" == Barbar Setup == 
" NOTE: If barbar's option dict isn't created yet, create it
let bufferline = get(g:, 'bufferline', {})

let bufferline.highlight_alternate = v:false


source ~/.config/nvim/lua/init.lua 
