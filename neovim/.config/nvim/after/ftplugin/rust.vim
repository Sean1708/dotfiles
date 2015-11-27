" Need cargo so that crates are handled but need to throw away the filename so use bash.
let g:neomake_rust_cargo_maker = {
  \ 'exe': 'bash',
  \ 'args': ['-c', 'cargo rustc -- -Z no-trans', '--'],
  \ 'errorformat':
    \ '%-G%f:%s:,' .
    \ '%f:%l:%c: %trror: %m,' .
    \ '%f:%l:%c: %tarning: %m,' .
    \ '%f:%l:%c: %m,'.
    \ '%f:%l: %trror: %m,'.
    \ '%f:%l: %tarning: %m,'.
    \ '%f:%l: %m',
\ }

let g:neomake_rust_enabled_makers = ['cargo']
