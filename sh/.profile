# config which works for bash and zsh #

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
# }}} Script Functions
# {{{ System-Specific Config
# system specific config goes in .sh/profile
if [[ -f "$HOME/.sh/profile" ]]
then
  source "$HOME/.sh/profile"
fi

if [[ -d "$HOME/.sh/scripts" ]]
then
  PATH="$HOME/.sh/scripts:$PATH"
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
alias julia-dev="$HOME/Downloads/src/julia-dev/julia"

if exists hub
then
  eval "$(hub alias -s)"
fi
# }}} Aliases
# {{{ Interactive Functions
# these functions can't be written as scripts since they must act on the current shell not a sub-shell
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
