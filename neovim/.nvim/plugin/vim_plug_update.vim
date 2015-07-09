set viminfo+=!
function! s:UpgradeVimPlugWeekly()
  let l:curtime = localtime()
  let l:weeks_since_update = floor((l:curtime - get(g:, 'VIM_PLUG_UPGRADE_TIME', 0)) / (7*24*60*60))
  if l:weeks_since_update >= 1
    let g:VIM_PLUG_UPGRADE_TIME = l:curtime
    if tolower(input("It's been " . string(l:weeks_since_update) . " week(s) since Vim-Plug was updated. Update now? <y/[n]> "))[0] == 'y'
      silent VimPlugUpgrade
    endif
  endif
endfunction

augroup UpgradeVimPlug
  autocmd!
  autocmd VimEnter * call <SID>UpgradeVimPlugWeekly()
augroup END
