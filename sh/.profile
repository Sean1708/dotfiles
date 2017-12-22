# CONFIG WHICH WORKS FOR BASH AND ZSH #

# System specific config goes in `.config/sh/profile`.
if [ -f "$HOME/.config/sh/profile" ]
then
	source "$HOME/.config/sh/profile"
fi

if hash nvim 2>/dev/null
then
	export EDITOR=nvim
elif hash vim 2>/dev/null
then
	export EDITOR=vim
else
	export EDITOR=vi
fi

if hash xclip 2>/dev/null
then
	alias copy='xclip -in -selection primary'
	alias paste='xclip -out -selection primary'
elif hash pbcopy 2>/dev/null && hash pbpaste 2>/dev/null
then
	alias copy='pbcopy'
	alias paste='pbpaste'
fi

# Start the SSH Agent if it hasn't already.
if hash ssh-agent 2>/dev/null && [ -z "$SSH_AUTH_SOCK" ]
then
	eval $(ssh-agent -s)
fi

# Some programs will only follow XDG if these are set.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="$HOME/.local/run"

# Directory for non-managed executables/libs/manpages.
export PATH="$HOME/.local/bin:$PATH"
export MANPATH="$HOME/.local/man:$MANPATH"
