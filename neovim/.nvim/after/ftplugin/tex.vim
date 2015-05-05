setlocal errorformat=%f:%l:\ %m

augroup LaTeX
  autocmd BufWritePost <buffer> Neomake chktex lacheck
augroup END

nnoremap <buffer> <localleader>m :write <bar> Neomake!<CR>
" two <CR>s so you don't get the "Press any key..."
nnoremap <buffer> <localleader>o :!open %:r.pdf<CR><CR>

function! s:Move(flags)
  let l:count = v:count1
  while l:count
    let [line, column] = searchpos('\v\C\\%(sub){0,2}section', a:flags)
    let l:count -= 1
  endwhile
  return [line, column]
endfunction

function! s:VMove(flags)
  let l:start_pos = getpos("'<")[1:2]
  call cursor(getpos("'>")[1:2])

  let l:end_pos = s:Move(a:flags)

  call cursor(start_pos)
  normal! v
  call cursor(end_pos)
endfunction

noremap <buffer> <silent> <script> ]] :<C-U>call <SID>Move('')<CR>
noremap <buffer> <silent> <script> [[ :<C-U>call <SID>Move('b')<CR>
vnoremap <buffer> <silent> <script> ]] :<C-U>call <SID>VMove('')<CR>
vnoremap <buffer> <silent> <script> [[ :<C-U>call <SID>VMove('b')<CR>
