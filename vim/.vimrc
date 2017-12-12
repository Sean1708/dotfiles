set nocompatible
filetype plugin indent on
syntax enable

" Display
set background=dark
set cursorline
set display+=lastline
set foldlevelstart=99
set laststatus=1
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set number
set relativenumber
set ruler
set rulerformat=%50(%=%m\ %y\ C:%c%V\ L:%l/%L\ %P%)
set showcmd
set textwidth=100

colorscheme solarized


" Editing
set autoindent
set backspace=indent,eol,start
set formatoptions+=o,r
set nojoinspaces
set nowrap
set scrolloff=1
set shiftround
set shiftwidth=4
set sidescroll=1
set sidescrolloff=5
set smarttab
set whichwrap=b,s,[,]
set wildmode=longest,list:full


" Options
set autoread
set autowriteall
set clipboard+=unnamed
set gdefault
set hlsearch
set ignorecase
set incsearch
set noswapfile
set smartcase
set spelllang=en_gb


let &softtabstop=&shiftwidth
let &statusline='%-f%=' . &rulerformat
let &tabstop=&shiftwidth


if $PREFER_SPACE == '1'
  set expandtab
else
  set noexpandtab
endif


augroup VimRC
  autocmd!
  autocmd FocusLost * silent! wall
augroup END

if has('nvim')
  augroup NeoVimRC
    autocmd!
    autocmd WinEnter term://* startinsert
  augroup END

  tnoremap <ESC><ESC> <C-\><C-n>
  tnoremap <S-Left> <C-\><C-n><C-w>h
  tnoremap <S-Down> <C-\><C-n><C-w>j
  tnoremap <S-Up> <C-\><C-n><C-w>k
  tnoremap <S-Right> <C-\><C-n><C-w>l
else
  set encoding=utf-8
endif

" Use Shift-<arrow key> to move around windows.
nnoremap <S-Left> <C-w>h
nnoremap <S-Down> <C-w>j
nnoremap <S-Up> <C-w>k
nnoremap <S-Right> <C-w>l

nnoremap <Left> :bprev<CR>
nnoremap <Right> :bnext<CR>
nnoremap <Down> <C-d>
nnoremap <Up> <C-u>

" ' is more convenient than , and has redundancy with `.
nnoremap ' ,

nnoremap Y y$

nnoremap <CR> za

" Use Ctrl-L to clear highlights.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

runtime macros/matchit.vim

" vim: foldmethod=marker foldlevel=0 expandtab shiftwidth=2
