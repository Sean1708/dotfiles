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

for cmd in vim nvim
do
    if [ ! -e ~/.${cmd}/bundle/Vundle.vim ]
    then
        git clone https://github.com/gmarik/Vundle.vim.git ~/.${cmd}/bundle/Vundle.vim
        ${cmd} +PluginInstall +qall
        mkdir ~/.${cmd}/backup
    fi
done
