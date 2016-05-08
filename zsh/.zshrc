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

unalias run-help; autoload run-help; alias '?'='run-help'
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

# {{{3 zsh-autoenv

AUTOENV_FILE_ENTER='.autoenv.in.zsh'
AUTOENV_FILE_LEAVE='.autoenv.out.zsh'
antigen bundle Tarrasch/zsh-autoenv

# }}}3 zsh-autoenv

antigen bundle python
antigen bundle safe-paste
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle zsh-users/zsh-syntax-highlighting

# }}}2 plugins
# {{{2 themes

antigen theme $HOME/.config/zsh/themes thematique

# }}}2 themes

antigen apply
# }}} antigen

# vim: foldmethod=marker foldlevel=0 tabstop=2 shiftwidth=2
