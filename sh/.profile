# CONFIG WHICH WORKS FOR BASH AND ZSH #

# system specific config goes in .config/sh/profile
if [ -f "$HOME/.config/sh/profile" ]
then
  source "$HOME/.config/sh/profile"
fi

# load nix
# TODO: start using nix
# if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]
# then
#     source "$HOME/.nix-profile/etc/profile.d/nix.sh"
# fi

if exists nvim
then
  export EDITOR=nvim
elif exists vim
then
  export EDITOR=vim
else
  export EDITOR=vi
fi

# some programs will only follow XDG of these are set
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="$HOME/.local/run"

# directory for user scripts and other non-managed executables
export PATH="$HOME/.local/bin:$PATH"
