## VARIABLES
# default text editor
export EDITOR=/usr/local/bin/vim

# make git stop complaining about brew
#export GIT_SSL_NO_VERIFY=1

# path to blog folder
export BLOG="${HOME}/Documents/Projects/sean1708.github.io"


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
# cd to dir then run ls
function cdl {
  # Argument Check
  local ARGS=1
  local E_BADARGS=85
  if [[ ! -e "${1}" ]]
  then
      echo "Error: Directory ${1} does not exist."
      return "${E_BADARGS}"
  elif [[ ! -d "${1}" ]]
  then
      echo "Error: File ${1} is not a directory."
      return "${E_BADARGS}"
  fi

  cd "${1}"
  ls
}

# mkdir then cd to that dir
function mcd {
  mkdir "${1}"
  cd "${1}"
}

# use newest homebrew sqlite
function sqlite {
  local SQLITE_DIR="/usr/local/Cellar/sqlite"
  local EXEC_FILE="bin/sqlite3"

  local lv_num="/0.0.0/"
  for dir in ${SQLITE_DIR}/**/
  do
      local cv_num=${dir:(-7):(7)}

      local l_maj=${lv_num:1:1}
      local c_maj=${cv_num:1:1}

      local l_min=${lv_num:3:1}
      local c_min=${cv_num:3:1}

      local l_pch=${lv_num:5:1}
      local c_pch=${cv_num:5:1}

      if [ "${c_maj}" -gt "${l_maj}" ]
      then
          lv_num=${cv_num}
      elif [ "${c_min}" -gt "${l_min}" ]
      then
          lv_num=${cv_num}
      elif [ "${c_pch}" -gt "${l_pch}" ]
      then
          lv_num=${cv_num}
      fi
  done

  local prgm="${SQLITE_DIR}${lv_num}${EXEC_FILE}"
  $prgm $@
}

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
