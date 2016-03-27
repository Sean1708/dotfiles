#!/usr/bin/env bash

for pkg in [^.]*
do
  if [[ -d "$pkg" ]]
  then
    echo -n "Stowing ${pkg}... "

    case "$pkg" in
      *vim | ipython | *sh)
        opts='--no-folding'
        ;;
      *)
        unset opts
        ;;
    esac
    stow --target="$HOME" $opts "$pkg"

    if [[ $? -eq 0 ]]
    then
      echo 'ok!'
    fi
  fi
done
