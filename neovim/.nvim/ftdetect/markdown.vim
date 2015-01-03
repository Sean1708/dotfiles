autocmd BufNewFile,BufRead *.md
    \ if &ft =~# '^\%(conf\|modula2\)$' |
    \   set filetype=markdown |
    \ else |
    \   setfiletype markdown |
    \ endif
