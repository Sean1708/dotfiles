let g:neomake_tex_make_maker = {'exe': 'make', 'errorformat': '%f:%l: %m'}

augroup NeomakeLaTeX
  autocmd!
  autocmd BufWritePost <buffer> Neomake chktex lacheck
augroup END

nnoremap <buffer> <localleader>m :update <bar> Neomake! tex_make<CR>
" TODO: how about jobstart for this?
" TODO: how about <silent> will that get rid of "Press any...", if not maybe use :silent
" two <CR>s so you don't get the "Press any key..."
nnoremap <buffer> <localleader>o :!open %:r.pdf<CR><CR>

" TODO: maybe use <expr> instead
noremap <buffer> <silent> ]] :<C-U>call move#Move('\v\C\\%(sub){0,2}section', '')<CR>
noremap <buffer> <silent> [[ :<C-U>call move#Move('\v\C\\%(sub){0,2}section', 'b')<CR>
vnoremap <buffer> <silent> ]] :<C-U>call move#VMove('\v\C\\%(sub){0,2}section', '')<CR>
vnoremap <buffer> <silent> [[ :<C-U>call move#VMove('\v\C\\%(sub){0,2}section', 'b')<CR>

setlocal spell
