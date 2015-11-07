function! kwp#KeywordPrg(...) range
  let l:count = string(get(a:000, 3, v:count))
  let l:keyword = get(a:000, 2, expand('<cword>'))
  let l:markup = get(a:000, 1, 'text')
  let l:program = get(a:000, 0, &keywordprg)

  if l:keyword == ''
    throw 'No identifier found!'
  elseif l:program == ''
    let l:program = ':help'
  endif

  if l:program =~ '\v\C<man>'
    if exists(':Man') != 2
      source $VIMRUNTIME/ftplugin/man.vim
    endif
    execute ':Man' l:count l:keyword
  elseif l:program[0] == ':'
    execute l:program[1:] l:keyword
  else
    echom l:program . ' ' . l:keyword
    let l:docstr = systemlist(l:program . ' ' . l:keyword)

    pclose
    botright 10new Documentation
    call append(0, l:docstr)
    call setpos('.', [0, 1, 1, 0])

    let &l:filetype = l:markup
    setlocal buftype=nofile bufhidden=delete nomodifiable
    setlocal previewwindow
  endif
endfunction
