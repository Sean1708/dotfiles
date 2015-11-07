function repl#REPL(index)
  if !exists('b:repl')
    let l:cmd = ''
  elseif type(b:repl) == type('')
    let l:cmd = b:repl
  else
    let l:cmd = b:repl[a:index]
  endif

  let l:cmd = substitute(l:cmd, '%:p', expand('%:p'), 'g')
  let l:cmd = substitute(l:cmd, '%', expand('%'), 'g')

  update

  if winwidth(0)/2 < 80
    botright new
  else
    vertical botright new
  endif

  if l:cmd == ''
    terminal
  else
    call termopen(l:cmd)
    startinsert
  endif
endfunction
