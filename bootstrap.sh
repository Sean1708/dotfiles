for pkg in [^.]*
do
    if [ ${pkg} != 'bootstrap.sh' ]
    then
        echo -n "Stowing ${pkg}... "

        stow --target=${HOME} ${pkg}

        if [ $? -ne 0 ]
        then
            echo 'failed.'
        else
            echo 'ok!'
        fi
    fi
done
