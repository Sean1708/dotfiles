let b:test_cmd = 'terminal nosetests'

nnoremap <buffer> <silent> K :call kwp#KeywordPrg('pydoc3', 'rst')<CR>

let s:prog = executable('ipython') ? 'ipython' : 'python3'
let b:repl = [s:prog, s:prog . ' -i %']
