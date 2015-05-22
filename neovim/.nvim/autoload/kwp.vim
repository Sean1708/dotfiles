function! kwp#KeywordPrg(...) range
  let l:keyword = get(a:000, 2, expand('<cword>'))
  let l:markup = get(a:000, 1, 'text')
  let l:program = get(a:000, 0, &keywordprg)

  if l:keyword == ''
    throw 'No identifier found!'
  elseif l:program == ''
    let l:program = ':help'
  endif

  if l:program[0] == ':'
    execute l:program[1:] l:keyword
    return 0
  elseif l:program =~ '\v\C<man>'
    let l:markup = 'groff'
    if v:count > 0
      let l:program .= ' ' . v:count
    else
      let l:program = substitute(l:program, '\v\C-s', '', '')
    endif
  endif

  echom l:program . ' ' . l:keyword
  let l:docstr = systemlist(l:program . ' ' . l:keyword)

  pclose
  botright 10new Documentation
  call append(0, l:docstr)
  call setpos('.', [0, 1, 1, 0])

  let &l:filetype = l:markup
  setlocal buftype=nofile bufhidden=delete nomodifiable
  setlocal previewwindow
endfunction