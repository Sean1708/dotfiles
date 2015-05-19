#!/usr/bin/env bash

for pkg in [^.]*
do
    if [ "${pkg}" != 'bootstrap.sh' -a "${pkg}" != 'README.md' ]
    then
        echo -n "Stowing ${pkg}... "

        case "${pkg}" in
            *vim | ipython)
                opts='--no-folding'
                ;;
            *)
                unset opts
                ;;
        esac
        stow --target="${HOME}" ${opts} "${pkg}"

        if [ $? -eq 0 ]
        then
            echo 'ok!'
        fi
    fi
done
