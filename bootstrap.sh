#!/usr/bin/env bash

for pkg in [^.]*
do
  if [[ -d "$pkg" ]]
  then
    echo -n "Stowing $pkg... "

    stow --target="$HOME" --no-folding "$pkg"

    if [[ $? -eq 0 ]]
    then
      echo 'ok!'
    fi
  fi
done
