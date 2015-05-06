let g:neomake_tex_make_maker = {'exe': 'make', 'errorformat': '%f:%l: %m'}

augroup NeomakeLaTeX
  autocmd!
  autocmd BufWritePost <buffer> Neomake chktex lacheck
augroup END

nnoremap <buffer> <localleader>m :write <bar> Neomake! tex_make<CR>
" two <CR>s so you don't get the "Press any key..."
nnoremap <buffer> <localleader>o :!open %:r.pdf<CR><CR>

noremap <buffer> <silent> <script> ]] :<C-U>call utils#Move('\v\C\\%(sub){0,2}section', '')<CR>
noremap <buffer> <silent> <script> [[ :<C-U>call utils#Move('\v\C\\%(sub){0,2}section', 'b')<CR>
vnoremap <buffer> <silent> <script> ]] :<C-U>call utils#VMove('\v\C\\%(sub){0,2}section', '')<CR>
vnoremap <buffer> <silent> <script> [[ :<C-U>call utils#VMove('\v\C\\%(sub){0,2}section', 'b')<CR>
