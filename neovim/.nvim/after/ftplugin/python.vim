let g:neomake_python_python3_maker = {
  \ 'args': ['-c',
    \ "from sys import argv, exit\n" .
    \ "if len(argv) != 2:\n" .
    \ "    exit(1)\n" .
    \ "try:\n" .
    \ "    compile(open(argv[1]).read(), argv[1], 'exec', 0, 1)\n" .
    \ "except IndentError as i:\n" .
    \ "    print('{i.filename}:{i.lineno}:{i.offset}: {i.msg}'.format(i=i))\n" .
    \ "    exit(2)\n" .
    \ "except SyntaxError as s:\n" .
    \ "    print('{s.filename}:{s.lineno}:{s.offset}: {s.msg} ({s.text})'.format(s=s))\n" .
    \ "    exit(3)\n",
  \ ],
  \ 'errorformat': '%E%f:%l:%c: %m',
\ }

let g:neomake_python_pep257_maker = {'errorformat': '%W%f:%l %.%#,%Z %#%t%n: %m'}

let g:neomake_python_flake8_maker = {
  \ 'args': ['--max-complexity', '10'],
  \ 'errorformat':
    \ '%E%f:%l: could not compile,%-Z%p^,' .
    \ '%A%f:%l:%c: %t%n %m,' .
    \ '%A%f:%l: %t%n %m,' .
    \ '%-G%.%#',
\ }

" NOTE: requires nose-terse-output: https://github.com/joakimkarlsson/nose-terse-output
let g:neomake_nosetests_maker = {
  \ 'args': ['--with-terseout'],
  \ 'errorformat': '%f:%l: %m',
\ }

augroup NeomakePython
  autocmd!
  autocmd BufWritePost <buffer> Neomake python3 flake8 pep257
augroup END

nnoremap <buffer> <localleader>t :update <bar> Neomake! nosetests <bar> copen<CR>
nnoremap <buffer> <silent> K :call kwp#KeywordPrg('pydoc3', 'rst')<CR>

" TODO: maybe use <expr> instead
noremap <buffer> <silent> ]] :<C-U>call move#Move('\v\C^\s*%(class<bar>def)', '')<CR>
noremap <buffer> <silent> [[ :<C-U>call move#Move('\v\C^\s*%(class<bar>def)', 'b')<CR>
vnoremap <buffer> <silent> ]] :<C-U>call move#VMove('\v\C^\s*%(class<bar>def)', '')<CR>
vnoremap <buffer> <silent> [[ :<C-U>call move#VMove('\v\C^\s*%(class<bar>def)', 'b')<CR>

let b:repl = ['python3', 'python3 -i %']

setlocal tabstop=4
setlocal indentkeys+=0(,0),0[,0]
