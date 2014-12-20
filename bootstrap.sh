#!/usr/bin/env bash

for pkg in [^.]*
do
    if [ ${pkg} != 'bootstrap.sh' ]
    then
        echo -n "Stowing ${pkg}... "

        stow --restow --target=${HOME} ${pkg}

        if [ $? -ne 0 ]
        then
            echo 'failed.'
        else
            echo 'ok!'
        fi
    fi

    # lookup if this can be done with stow
    # stow ignores .gitignore annoyingly
    echo -n "Stowing .gitignore... "

    rm -f "${HOME}/.gitignore"
    ln -s git/.gitignore "${HOME}"
    
    if [ $? -ne 0 ]
    then
        echo 'failed.'
    else
        echo 'ok!'
    fi
done
