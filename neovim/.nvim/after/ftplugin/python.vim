nnoremap <buffer> <localleader>t :update <bar> terminal nosetests<CR>
nnoremap <buffer> <silent> K :call kwp#KeywordPrg('pydoc3', 'rst')<CR>

let b:repl = ['python3', 'python3 -i %']
