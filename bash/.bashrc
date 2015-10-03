# {{{ Script Functions
error() {
  local last_status="${2:-$?}"
  echo "Error: ${1:-Unknown}" 1>&2
  # interrupt interactive shells rather than exit
  if [[ $- == *i* ]]
  then
    kill -INT $$
  else
    exit ${2:-1}
  fi
}

exists() {
  if [[ "$#" -eq 1 ]]
  then
    hash "$1" 2>/dev/null
  else
    error 'Must specifiy exactly one command.'
  fi
}

# make these available to non-interactive shells
export -f error
export -f exists
# }}} Script Functions
# {{{ System-Specific Config
# system specific config goes in .bash/profile
if [[ -f "$HOME/.bash/profile" ]]
then
  source "$HOME/.bash/profile"
fi

if [[ -d "$HOME/.bash/scripts" ]]
then
  PATH="$HOME/.bash/scripts:$PATH"
fi

if exists nvim
then
  export EDITOR=nvim
elif exists vim
then
  export EDITOR=vim
else
  export EDITOR=vi
fi
# }}} System-Specifc Config
# {{{ Aliases
alias jekyll="bundle exec jekyll"
alias julia-dev="$HOME/Downloads/src/julia-dev/julia"

if exists hub
then
  eval "$(hub alias -s)"
fi
# }}} Aliases
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

colour_last_status() {
  local last_status="$?"
  if [[ "$last_status" -eq "0" ]]
  then
    echo "$txtgrn$last_status$txtrst"
  else
    echo "$txtred$last_status$txtrst"
  fi
}

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
    else
      echo ''
    fi
  fi
}

PS1='\[$txtpur\]\u:\W $(colour_last_status)\[$txtcyn\]$(git_branch)\[$txtred\]$(git_dirty)\[$txtblu\]\$\[$txtrst\] '
# }}} Prompt Customisation
# {{{ Interactive Functions
# these functions can'tbe written as scripts since they must act on the current shell not a sub-shell
cdl() {
  if [[ ! -e "$1" ]]
  then
    error "Directory $1 does not exist."
  elif [[ ! -d "$1" ]]
  then
    error "File $1 is not a directory."
  fi

  # `cd` has no useful command line arguments
  cd "$1"
  shift
  ls $@
}

mcd() {
  mkdir "$1"
  cd "$1"
}
# }}} Interactive Functions

# vim: foldmethod=marker foldlevel=0
