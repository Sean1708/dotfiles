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

# TODO: no cap letters and prgm is not needed
# use newest homebrew sqlite
function sqlite {
  local SQLITE_DIR="/usr/local/Cellar/sqlite"
  local EXEC_FILE="bin/sqlite3"

  local lv_num="/0.0.0.0/"
  for dir in ${SQLITE_DIR}/**/
  do
    local cv_num=${dir:(-9):9}

    local l_maj=${lv_num:1:1}
    local c_maj=${cv_num:1:1}

    local l_min=${lv_num:3:1}
    local c_min=${cv_num:3:1}

    local l_pch=${lv_num:5:1}
    local c_pch=${cv_num:5:1}

    local l_min_pch=${lv_num:7:1}
    local c_min_pch=${cv_num:7:1}

    if [ "${c_maj}" -gt "${l_maj}" ]
    then
      lv_num=${cv_num}
    elif [ "${c_min}" -gt "${l_min}" ]
    then
      lv_num=${cv_num}
    elif [ "${c_pch}" -gt "${l_pch}" ]
    then
      lv_num=${cv_num}
    elif [ "${c_min_pch}" -gt "${l_min_pch}" ]
    then
      lv_num=${cv_num}
    fi
  done

  local prgm="${SQLITE_DIR}${lv_num}${EXEC_FILE}"
  $prgm $@
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
