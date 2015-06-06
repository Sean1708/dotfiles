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
  if [[ $# -e 1 ]]
  then
    hash "$1" 2>/dev/null
  else
    error 'Must specifiy exactly one command.'
  fi
}


# system specific config goes in .bashrc
if [[ -f "$HOME/.bashrc" ]]
then
  source "$HOME/.bashrc"
fi

if [[ -d "$HOME/.bash_scripts" ]]
then
  PATH="$HOME/.bash_scripts:$PATH"
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


if exists bundle
then
  alias jekyll="bundle exec jekyll"
fi

if [[ -d "$HOME/Downloads/src/julia-dev/julia" ]]
then
  alias julia-dev="$HOME/Downloads/src/julia-dev/julia"
fi

if exists hub
then
  eval "$(hub alias -s)"
fi


cdl() {
  if [[ ! -e "$1" ]]
  then
    error "Directory $1 does not exist."
  elif [[ ! -d "$1" ]]
  then
    error "File $1 is not a directory."
  fi

  cd "$1"
  ls
}

mcd() {
  mkdir "$1"
  cd "$1"
}
