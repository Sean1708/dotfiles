# these two functions are needed for initialisation
fpath=($HOME/.config/sh/utils $fpath)
autoload error
autoload exists

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

unalias run-help; autoload run-help
autoload mcd
autoload cdl

# {{{ antigen

export ADOTDIR="$HOME/.local/share/antigen"

# load up antigen
if [[ -f "$HOME/.config/zsh/antigen/antigen.zsh" ]]
then
    source "$HOME/.config/zsh/antigen/antigen.zsh"
fi

antigen use oh-my-zsh

# {{{2 plugins

antigen bundle brew
# antigen bundle compleat
antigen bundle gitfast
# antigen bundle git-extras
antigen bundle pip
# antigen bundle pyenv  # or maybe antigen bundle Tarrasch/zsh-autoenv  # or both
antigen bundle python
antigen bundle zsh-users/zsh-syntax-highlighting

# }}}2 plugins
# {{{2 themes

antigen theme $HOME/.config/zsh/themes thematique

# }}}2 themes

antigen apply
# }}} antigen

# vim: foldmethod=marker foldlevel=0 tabstop=2 shiftwidth=2
