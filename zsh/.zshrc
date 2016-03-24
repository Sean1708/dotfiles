# TODO: I'm thinking a theme like
#     [<user>@<start of domain>:<location> | git:<branch><status symbols> | env:<env name>]
#     »                                127 ↵ alway green when 0

# system specific zsh config goes in .zsh/profile
if [[ -f "$HOME/.config/zsh/profile" ]]
then
  source "$HOME/.config/zsh/profile"
fi

# config compatible with bash and zsh
if [[ -f "$HOME/.profile" ]]
then
  source "$HOME/.profile"
fi

unalias run-help
autoload run-help

# {{{ antigen

export ADOTDIR="$HOME/.local/share/antigen"

# load up antigen
if [[ -f "$HOME/.config/zsh/antigen/antigen.zsh" ]]
then
    source "$HOME/.config/zsh/antigen/antigen.zsh"
fi

antigen use oh-my-zsh

# {{{2 themes

# antigen theme gallifrey
antigen theme kphoen

# }}}2 themes
# {{{2 plugins

antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle brew
# antigen bundle compleat
# antigen bundle pip
# antigen bundle pyenv  # or maybe antigen bundle Tarrasch/zsh-autoenv  # or both
# antigen bundle sudo

# }}}2 plugins
# }}} antigen

# vim: foldmethod=marker foldlevel=0 tabstop=2 shiftwidth=2
