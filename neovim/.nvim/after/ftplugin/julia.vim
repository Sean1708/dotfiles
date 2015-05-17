let g:neomake_julia_lint_maker = {
  \ 'exe': 'julia',
  \ 'args': ['-e',
    \ "import Lint\n" .
    \ "if isempty(ARGS)\n" .
    \ "  exit(2)\n" .
    \ "else\n" .
    \ "  isempty(Lint.lintfile(ARGS[1])) || exit(1)\n" .
    \ "end",
  \ ],
  \ 'errorformat': '%f:%l [%.%#] %t%[%^ ]%# %#%m',
\ }

" TODO: give FactCheck a setstyle(:machine) for file:line: code error (should also set :compact)
" let g:neomake_julia_test_maker = {
"   \ 'exe': 'julia',
"   \ 'args': ['-e',
"     \ "import FactCheck\n" .
"     \ "FactCheck.setstyle(:machine)\n" .
"     \ "include(\"test/runtests.jl\")\n" .
"     \ "FactCheck.exitstatus()\n",
"   \ ],
"   \ 'errorformat': '%f:%l: %t %m',
" \ }

augroup NeomakeJulia
  autocmd!
  autocmd BufWritePost <buffer> Neomake lint
augroup END

" TODO: use Neomake for this
nnoremap <buffer> <localleader>t :update <bar> !julia test/runtests.jl<CR>
nnoremap <buffer> K :call utils#KeywordPrg("julia -e 'help(ARGS[1])'", 'markdown')<CR>
