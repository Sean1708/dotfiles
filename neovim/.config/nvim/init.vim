" TODO:
" - remove
"     - python-mode
"         - neomake gets most of the way there
"         - might need better syntax highlighting
"         - virtualenv support
"             - automatically pip install neovim
" - add
"     - YouCompleteMe
" TODO: Defaults will be changing soon (https://github.com/neovim/neovim/issues/2676)
" PLUGINS {{{1

let g:plug_window = 'if winwidth(0)/2 < 80 | topleft new | else | vertical topleft new | endif'
command! UpgradePlugins silent PlugUpgrade | silent PlugUpdate | quit | silent UpdateRemotePlugins
" Install vim-plug if it isn't already.
if !filereadable($HOME . '/.config/nvim/autoload/plug.vim')
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * UpgradePlugins
endif

call plug#begin('~/.cache/nvim/plugged')

Plug 'powerman/vim-plugin-viewdoc'
Plug 'Chiel92/vim-autoformat'
Plug 'ervandew/supertab'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'JuliaLang/julia-vim'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'klen/python-mode'
Plug 'haya14busa/incsearch.vim'
Plug 'vim-scripts/repmo.vim'
Plug 'cespare/vim-toml'
Plug 'chrisbra/csv.vim'
Plug 'flazz/vim-colorschemes'

call plug#end()

" }}}1 END PLUGINS
" GENERAL {{{1

filetype plugin indent on
syntax enable

set foldlevelstart=99

set spelllang=en_gb

set noswapfile
set autowriteall

set lazyredraw

set clipboard+=unnamed

augroup NeoVimRC
  autocmd!
  autocmd FocusLost * silent wall
  " TODO: need to prevent removing trailing whitespace in vim script because ...?
  autocmd BufWritePre *
        \ if &filetype !=? 'markdown' && &filetype !=? 'vim' && expand('%:t') !~ '\v\c^n\?vimrc$' |
        \   silent %s/\s\+$//e |
        \ endif
  autocmd WinEnter term://* startinsert
augroup END

" }}}1 END GENERAL
" MAPPINGS {{{1

tnoremap <ESC><ESC> <C-\><C-n>

nnoremap <S-Left> <C-w>h
nnoremap <S-Down> <C-w>j
nnoremap <S-Up> <C-w>k
nnoremap <S-Right> <C-w>l
tnoremap <S-Left> <C-\><C-n><C-w>h
tnoremap <S-Down> <C-\><C-n><C-w>j
tnoremap <S-Up> <C-\><C-n><C-w>k
tnoremap <S-Right> <C-\><C-n><C-w>l

nnoremap <Left> :bprev<CR>
nnoremap <Right> :bnext<CR>
nnoremap <Down> <C-d>
nnoremap <Up> <C-u>

" ' is more convenient than , and has redundancy with `
nnoremap ' ,

nnoremap Y y$

" }}}1 END MAPPINGS
" EDITING {{{1

set complete+=i
set omnifunc=syntaxcomplete#Complete

set nrformats+=alpha

set whichwrap=h,l
set nojoinspaces

set shiftround

set formatoptions+=r,o

" incsearch doesn't set magic in substitutions
cnoremap s/ s/\v

set ignorecase
set smartcase
set gdefault

" }}}1 END EDITING
" DISPLAY {{{1

set cursorline
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set number
set relativenumber

set showcmd
set noshowmode

set textwidth=100
set nowrap
set shiftwidth=4
let &tabstop=&shiftwidth
let &softtabstop=&shiftwidth

set sidescroll=1
set scrolloff=1
set sidescrolloff=5

if $PREFER_TAB == '1'
  set noexpandtab
else
  set expandtab
endif

" }}}1 END DISPLAY
" PLUGIN-SETTINGS {{{1
" VIEWDOC {{{2

let g:viewdoc_open = "topleft new"
let g:viewdoc_openempty = 0

" TODO: syntax highlight python with rst
if $PREFER_PYTHON2 == '1'
  let g:viewdoc_pydoc_cmd = 'pydoc'
else
  let g:viewdoc_pydoc_cmd = 'pydoc3'
endif

" }}}2 END VIEWDOC
" SUPERTAB {{{2

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<C-n>'
let g:SuperTabLongestEnhaced = 1
let g:SuperTabCrMapping = 1
let g:SuperTabCompleteCase = 'match'
autocmd FileType * call SuperTabChain(&omnifunc, '<C-n>')

" }}}2 END SUPERTAB
" NEOMAKE {{{2

function! s:Update()
  if len(expand('%')) != 0
    update
  endif
endfunction

augroup Neomake
  autocmd!
  autocmd InsertLeave,BufWritePost * call <SID>Update() | Neomake
augroup END

" }}}2 END NEOMAKE
" AIRLINE {{{2

let g:airline#extensions#tabline#enabled = 1

" }}}2 END AIRLINE
" RUST.VIM {{{2

let g:rust_fold = 1
let g:rust_bang_comment_leader = 1

" }}}2 END RUST
" PYTHON-MODE {{{2

if $PREFER_PYTHON2 == '1'
  let g:pymode_python = 'python'
else
  let g:pymode_python = 'python3'
  let g:pymode_syntax_print_as_function = 1
endif

let g:pymode_doc = 0
let g:pymode_run = 0
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_indent = 0
let g:pymode_breakpoint = 0
let g:pymode_options_colorcolumn = 0

" }}}2 END PYTHON-MODE
" INCSEARCH.VIM {{{2

map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

let g:incsearch#auto_nohlsearch = 1
map n <Plug>(incsearch-nohl-n)
map N <Plug>(incsearch-nohl-N)
map * <Plug>(incsearch-nohl-*)
map # <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

let g:incsearch#consistent_n_direction = 1

let g:incsearch#magic = '\v'

" }}}2 END INCSEARCH
" COLORSCHEMES {{{2

set background=dark
colorscheme solarized

" }}}2 END COLORSCHEMES
" }}}1 END PLUGIN-SETTINGS

" vim: foldmethod=marker foldlevel=0 expandtab shiftwidth=2
