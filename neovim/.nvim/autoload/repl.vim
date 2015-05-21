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

  botright new
  if l:cmd == ''
    terminal
  else
    call termopen(l:cmd)
    startinsert
  endif
endfunction
