# system specific bash config goes in .bash/profile
if [[ -f "$HOME/.bash/profile" ]]
then
  source "$HOME/.bash/profile"
fi

# config compatible with bash and zsh
if [[ -f "$HOME/.profile" ]]
then
  source "$HOME/.profile"
fi

# {{{ Prompt Customisation
# heavily influenced by https://github.com/jimeh/git-aware-prompt
txtblk="$(tput setaf 0 2>/dev/null || echo '\e[0;30m')"  # Black
txtred="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"  # Red
txtgrn="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"  # Green
txtylw="$(tput setaf 3 2>/dev/null || echo '\e[0;33m')"  # Yellow
txtblu="$(tput setaf 4 2>/dev/null || echo '\e[0;34m')"  # Blue
txtpur="$(tput setaf 5 2>/dev/null || echo '\e[0;35m')"  # Purple
txtcyn="$(tput setaf 6 2>/dev/null || echo '\e[0;36m')"  # Cyan
txtwht="$(tput setaf 7 2>/dev/null || echo '\e[0;37m')"  # White
txtrst="$(tput sgr 0 2>/dev/null || echo '\e[0m')"  # Text Reset

git_branch() {
  if exists git
  then
    local branch
    if branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    then
      if [[ "$branch" == 'HEAD' ]]
      then
        branch='detached*'
      fi
      echo " ($branch)"
    fi
  fi
}

git_dirty() {
  if exists git
  then
    local status="$(git status --porcelain 2> /dev/null)"
    if [[ "$status" != '' ]]
    then
      echo '*'
    fi
  fi
}

PROMPT_COMMAND="last_status=\"\$?\"; $PROMPT_COMMAND"
case "$TERM" in
*color*) PS1='\[$txtpur\]\u@\h:\W \[$([[ $last_status -eq "0" ]] && echo $txtgrn || echo $txtred)\]$last_status\[$txtcyn\]$(git_branch)\[$txtred\]$(git_dirty)\[$txtblu\]\$\[$txtrst\] ';;
*) PS1='\u@\h:\W $last_status$(git_branch)$(git_dirty)\$ ';;
esac
# }}} Prompt Customisation

# vim: foldmethod=marker foldlevel=0
