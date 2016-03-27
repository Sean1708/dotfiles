# config which works for bash and zsh #

# {{{ System-Specific Config
# system specific config goes in .sh/profile
if [[ -f "$HOME/.config/sh/profile" ]]
then
  source "$HOME/.config/sh/profile"
fi

if [[ -d "$HOME/.config/sh/scripts" ]]
then
  PATH="$HOME/.config/sh/scripts:$PATH"
fi

if exists nvim
then
  export EDITOR=nvim
elif exists vim
then
  export EDITOR=vim
else
  export EDITOR=vi
fi
# }}} System-Specifc Config
# {{{ Aliases
if exists hub
then
  eval "$(hub alias -s)"
fi
# }}} Aliases
# {{{ Interactive Functions
# }}} Interactive Functions

# vim: foldmethod=marker foldlevel=0
