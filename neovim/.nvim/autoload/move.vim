function! move#Move(pattern, flags)
  let l:count = v:count1
  while l:count
    let [line, column] = searchpos(a:pattern, a:flags)
    let l:count -= 1
  endwhile
  return [line, column]
endfunction

function! move#VMove(pattern, flags)
  let l:start_pos = getpos("'<")[1:2]
  call cursor(getpos("'>")[1:2])

  let l:end_pos = move#Move(a:pattern, a:flags)

  call cursor(start_pos)
  normal! v
  call cursor(end_pos)
endfunction
