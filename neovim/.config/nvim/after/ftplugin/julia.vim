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

let g:neomake_julia_enabled_makers = ['lint']
let b:test_cmd = 'terminal julia --color test/runtests.jl'

nnoremap <buffer> K :call kwp#KeywordPrg("julia -e 'help(ARGS[1])'", 'markdown')<CR>
