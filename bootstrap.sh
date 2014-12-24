#!/usr/bin/env bash

for pkg in [^.]*
do
    if [ "${pkg}" != 'bootstrap.sh' ]
    then
        echo -n "Stowing ${pkg}... "

        case ${pkg} in
            git)
                opts='--override=\.gitignore'
                ;;
            *vim | ipython)
                opts='--no-folding'
                ;;
            *)
                unset opts
                ;;
        esac
        stow "${opts}" --target="${HOME}" "${pkg}"

        if [ $? -ne 0 ]
        then
            echo 'failed.'
        else
            echo 'ok!'
        fi
    fi
done

# automatically install Vundle.vim and vim stuffs
