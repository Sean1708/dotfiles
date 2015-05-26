let g:neomake_rust_rustc_maker = {
  \ 'args': ['-Z', 'parse-only'],
  \ 'errorformat':
    \ '%E%f:%l:%c: %\d%#:%\d%# %.%\{-}error:%.%\{-} %m,'   .
    \ '%W%f:%l:%c: %\d%#:%\d%# %.%\{-}warning:%.%\{-} %m,' .
    \ '%C%f:%l %m,' .
    \ '%-Z%.%#'
\ }

let g:neomake_cargo_build_maker = {
  \ 'exe': 'cargo',
  \ 'args': ['build'],
  \ 'errorformat':
    \ '%-G%f:%s:,' .
    \ '%f:%l:%c: %trror: %m,' .
    \ '%f:%l:%c: %tarning: %m,' .
    \ '%f:%l:%c: %m,'.
    \ '%f:%l: %trror: %m,'.
    \ '%f:%l: %tarning: %m,'.
    \ '%f:%l: %m',
\ }

" TODO: I think cargo test needs a different errorformat to cargo build
let g:neomake_cargo_test_maker = {
  \ 'exe': 'cargo',
  \ 'args': ['test'],
  \ 'errorformat':
    \ '%-G%f:%s:,' .
    \ '%f:%l:%c: %trror: %m,' .
    \ '%f:%l:%c: %tarning: %m,' .
    \ '%f:%l:%c: %m,'.
    \ '%f:%l: %trror: %m,'.
    \ '%f:%l: %tarning: %m,'.
    \ '%f:%l: %m',
\ }


augroup NeomakeRust
  autocmd!
  autocmd BufWritePost <buffer> Neomake rustc
augroup END

nnoremap <buffer> <localleader>m :update <bar> Neomake! cargo_build<CR>
nnoremap <buffer> <localleader>t :update <bar> Neomake! cargo_test<CR>
