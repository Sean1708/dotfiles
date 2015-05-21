## VARIABLES
# default text editor
export EDITOR=/usr/local/bin/nvim

# path to blog folder
export BLOG="${HOME}/Projects/sean1708.github.io"


## ALIASES
# use github-pages jekyll not system jekyll
alias jekyll="bundle exec jekyll"

# cd to blog folder
alias goto_blog="cd ${BLOG}"

# alias git to hub
eval "$(hub alias -s)"

# using homebrew causes GMP mismatch
alias julia-dev="${HOME}/Downloads/src/julia-dev/julia"


## FUNCTIONS
function error {
  echo "Error: ${1:-"Unknown"}"
  kill -INT $$
}

# cd to dir then run ls
function cdl {
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

# mkdir then cd to that dir
function mcd {
  mkdir "${1}"
  cd "${1}"
}

# not that much quicker to type but at least I don't have to remember how to
# spell caffeinate
function nosleep {
  caffeinate -dim
}

# use newest homebrew sqlite
function sqlite {
  local sqlite_dir="/usr/local/Cellar/sqlite/"
  local exec_file="/bin/sqlite3"

  local latest_version_string="0.0.0.0"
  for dir in ${sqlite_dir}/**/
  do
    IFS='.' read -a latest_version <<< "${latest_version_string}"
    local current_version_string=$(basename "${dir}")
    IFS='.' read -a current_version <<< "${current_version_string}"
    for i in 0 1 2 3
    do
      if [ "${current_version[i]}" -gt "${latest_version[i]}" ]
      then
        latest_version_string="${current_version_string}"
        break
      elif [ "${current_version[i]}" -lt "${latest_version[i]}" ]
      then
        break
      fi
    done
  done

  ${sqlite_dir}${latest_version_string}${exec_file} $@
}

# TODO: I need to change this now that 3.0.0 is out
# make `ijulia` args into `ipython3 args --profile=julia` and `ijulia` into
# `ipython3 console --profile=julia`
function ijulia {
  local mode="false"

  for a
  do
    case "$a" in
      console)
        mode="true"
        ;;
      qtconsole)
        mode="true"
        ;;
      notebook)
        mode="true"
        ;;
    esac
  done

  if [ "$mode" == "true" ]
  then
    ipython3 $@ --profile=julia
  else
    ipython3 console $@ --profile=julia
  fi
}

function magnet {
  pushd ~/Downloads/torrents/.watch || error "Could not find .watch directory."
  [[ "$1" =~ xt=urn:btih:([^&/]+) ]] || error "Bad magnet link."

  local hashh=${BASH_REMATCH[1]}
  if [[ "$1" =~ dn=([^&/]+) ]]
  then
    local filename=${BASH_REMATCH[1]}
  else
    local filename=$hashh
  fi

  echo "d10:magnet-uri${#1}:${1}e" > "meta-$filename.torrent"
  echo "Sucessful! :D"
  popd
}

function ltx-init {
  if [ ! -f Makefile ]
  then
    curl -sO https://raw.githubusercontent.com/Sean1708/LaTeX-Build-Files/master/Makefile || error 'Could not download Makefile.'
  fi
  if [ ! -f .gitignore ]
  then
    curl -sO https://raw.githubusercontent.com/Sean1708/LaTeX-Build-Files/master/.gitignore || error 'Could not download Makefile.'
  fi
}
