# These two functions are needed for initialisation.
fpath=($HOME/.local/share/sh/functions $fpath)
autoload error
autoload exists

# Config compatible with bash and zsh.
if [[ -f "$HOME/.profile" ]]
then
	source "$HOME/.profile"
fi

# System specific zsh config.
if [[ -f "$HOME/.config/zsh/profile" ]]
then
	source "$HOME/.config/zsh/profile"
fi

unalias run-help; autoload -Uz run-help; alias '?'='run-help'; alias 'help'='run-help'
autoload mcd
autoload cdl

# {{{ antigen

export ANTIGEN_HOME="$(realpath --relative-to "$HOME" "$XDG_RUNTIME_DIR")/antigen"
mkdir -p "$ANTIGEN_HOME"

export ANTIGEN_REPO="$ANTIGEN_HOME/repo"
mkdir -p "$ANTIGEN_REPO"

export ADOTDIR="$ANTIGEN_HOME/dotdir"
mkdir -p "$ADOTDIR"


if ! [[ -f "$ANTIGEN_REPO/antigen.zsh" ]]
then
	git clone https://github.com/zsh-users/antigen.git "$ANTIGEN_REPO"
fi

source "$ANTIGEN_REPO/antigen.zsh"


antigen use oh-my-zsh

# Must go first otherwise it overwrites key bindings.
antigen bundle vi-mode

# {{{2 plugins

antigen bundle gitfast
antigen bundle git-extras
antigen bundle httpie
antigen bundle pip
antigen bundle python
antigen bundle safe-paste
antigen bundle sudo

# {{{3 zsh-autoenv

AUTOENV_FILE_ENTER='.autoenv.in.zsh'
AUTOENV_FILE_LEAVE='.autoenv.out.zsh'
antigen bundle Tarrasch/zsh-autoenv

# }}}3 zsh-autoenv
# {{{3 autoupdate-antigen.zshplugin

ANTIGEN_SYSTEM_RECEIPT_F="$ANTIGEN_HOME/.autoupdate-antigen_system_lastupdate"
ANTIGEN_PLUGIN_RECEIPT_F="$ANTIGEN_HOME/.autoupdate-antigen_plugin_lastupdate"
antigen bundle unixorn/autoupdate-antigen.zshplugin

# }}}3 autoupdate-antigen.zshplugin
antigen bundle zlsun/solarized-man
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# }}}2 plugins
# {{{2 themes

antigen theme $HOME/.config/zsh/themes thematique

# }}}2 themes

# TODO: Delete all aliases.
antigen apply
# }}} antigen

# vim: foldmethod=marker foldlevel=0
