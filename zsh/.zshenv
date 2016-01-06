# TODO: have .config/bash, .config/sh, and .config/zsh
# system specific zsh config goes in .zsh/profile
if [[ -f "$HOME/.zsh/profile" ]]
then
  source "$HOME/.zsh/profile"
fi

# config compatible with bash and zsh
if [[ -f "$HOME/.profile" ]]
then
    source "$HOME/.profile"
fi

# {{{ antigen

export ADOTDIR="$HOME/.local/share/antigen"

# load up antigen
if [[ -f "$HOME/.zsh/antigen/antigen.zsh" ]]
then
    source "$HOME/.zsh/antigen/antigen.zsh"
fi

antigen use oh-my-zsh

# {{{2 themes

# antigen theme gallifrey
antigen theme kphoen

# }}}2 themes
# }}} antigen

# vim: foldmethod=marker foldlevel=0
