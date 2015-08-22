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
  \ 'buffer_output': 1,
\ }

let g:neomake_enabled_makers = ['cargo']
let g:neomake_rust_enabled_makers = ['rustc']

let b:test_cmd = 'Neomake! cargo_test'
