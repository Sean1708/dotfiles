" TODO: Get rid of:
"     - Fugitive
"         - All I want is the branch, maybe that comes with airline
"     - supertab
"         - will just using deoplete solve this
"     - buftabline
"         - airline
"     - python-mode
"         - neomake gets most of the way there
"         - might need better syntax highlighting
"         - virtualenv support
"             - automatically pip install neovim
" TODO: Anything (including Fugitive) that comes from a plugin should have an
"     if_has guard around it.
" TODO: Defaults will be changing soon (https://github.com/neovim/neovim/issues/2676)
" PLUGINS {{{1

let g:plug_window = 'if winwidth(0)/2 < 80 | topleft new | else | vertical topleft new | endif'
" launchd uses this command so don't fucking delete it!
command! UpgradePlugins silent PlugUpgrade | silent PlugUpdate | quit | silent UpdateRemotePlugins
if !filereadable($HOME . '/.config/nvim/autoload/plug.vim')
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * UpgradePlugins
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'ervandew/supertab'
Plug 'benekastah/neomake'
Plug 'ap/vim-buftabline'
Plug 'JuliaLang/julia-vim'
Plug 'rust-lang/rust.vim'
Plug 'critiqjo/lldb.nvim', {'for': ['rust', 'c']}
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
  autocmd BufWritePre *
        \ if &filetype !=? 'markdown' && &filetype !=? 'vim' && expand('%:t') !~ '\v\c^n\?vimrc$' |
        \   silent %s/\s\+$//e |
        \ endif
  autocmd WinEnter term://* startinsert
augroup END

" }}}1 END GENERAL
" MAPPINGS {{{1

" maps <C-Space>
" TODO: how fragile is this?
inoremap <NUL> <ESC>
vnoremap <NUL> <ESC>
tnoremap <ESC><ESC> <C-\><C-N>

nnoremap <S-Left> <C-W>h
nnoremap <S-Down> <C-W>j
nnoremap <S-Up> <C-W>k
nnoremap <S-Right> <C-W>l
tnoremap <S-Left> <C-\><C-N><C-W>h
tnoremap <S-Down> <C-\><C-N><C-W>j
tnoremap <S-Up> <C-\><C-N><C-W>k
tnoremap <S-Right> <C-\><C-N><C-W>l

nnoremap <Left> :bprev<CR>
nnoremap <Right> :bnext<CR>
nnoremap <Down> <C-D>
nnoremap <Up> <C-U>

" ' is more convenient than , and has redundancy with `
nnoremap ' ,

nnoremap Y y$

nnoremap <silent> K :<C-U>call kwp#KeywordPrg()<CR>
nnoremap <silent> <leader>t :update <BAR> execute b:test_cmd<CR>

" }}}1 END MAPPINGS
" EDITING {{{1

" TODO: only set kspell when in text, markdown or latex.
set complete+=kspell,i
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

set number
set relativenumber

set ruler
set rulerformat=%40(%t%=\ %P:\ %4l:\ %3c%)
set laststatus=1
set showcmd

set textwidth=100
set nowrap
set shiftwidth=4  " columns added/removed when changing indent level
let &softtabstop=&shiftwidth  " amount of whitespace corresponding to tab presses
set expandtab

" }}}1 END DISPLAY
" PLUGIN-SETTINGS {{{1
" SUPERTAB {{{2

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<C-N>'
let g:SuperTabLongestEnhaced = 1
let g:SuperTabCrMapping = 1
let g:SuperTabCompleteCase = 'match'
autocmd FileType * call SuperTabChain(&omnifunc, '<C-N>')

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

nnoremap <localleader>m :update <bar> Neomake!<CR>

" }}}2 END NEOMAKE
" BUFTABLINE {{{2

let g:buftabline_show = 1
let g:buftabline_indicators = 1
let g:buftabline_seperators = 1

highlight link BufTabLineCurrent StatusLine
highlight link BufTablineActive StatusLineNC
highlight link BufTablineHidden Normal
highlight link BufTablineFill Normal

" }}}2 END BUFTABLINE
" RUST.VIM {{{2

let g:rust_fold = 1
let g:rust_bang_comment_leader = 1

" }}}2 END RUST
" PYTHON-MODE {{{2

let g:pymode_python = 'python3'
let g:pymode_lint_checkers = ['pyflakes', 'pylint', 'pep8', 'pep257', 'mccabe']
let g:pymode_syntax_print_as_function = 1

let g:pymode_options_colorcolumn = 0
let g:pymode_doc = 0
let g:pymode_run = 0
let g:pymode_rope = 0

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

" vim: foldmethod=marker foldlevel=0
