# this is `source`d for login shells whereas '.bashrc' is `source`d only for non-login
# I have no config which is login specific so I can happily `source` '.bashrc' from here

if [[ -f "$HOME/.bashrc" ]]
then
    source "$HOME/.bashrc"
fi
