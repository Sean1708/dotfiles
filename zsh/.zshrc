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

export ANTIGEN_HOME="$XDG_RUNTIME_DIR/antigen"
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


# TODO: Stop using Oh-My-Zsh, but figure out what things it sets.
antigen use oh-my-zsh

# {{{2 plugins

# TODO: Just load the standard git zsh completions.
antigen bundle gitfast
antigen bundle safe-paste
antigen bundle sudo

# {{{3 autoupdate-antigen.zshplugin

ANTIGEN_SYSTEM_RECEIPT_F="$(realpath --relative-to "$HOME" "$ANTIGEN_HOME")/.autoupdate-antigen_system_lastupdate"
ANTIGEN_PLUGIN_RECEIPT_F="$(realpath --relative-to "$HOME" "$ANTIGEN_HOME")/.autoupdate-antigen_plugin_lastupdate"
antigen bundle unixorn/autoupdate-antigen.zshplugin

# }}}3 autoupdate-antigen.zshplugin
antigen bundle zlsun/solarized-man
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# }}}2 plugins
# TODO: Use a stock theme.
# {{{2 themes

antigen theme $HOME/.config/zsh/themes thematique

# }}}2 themes

antigen apply

# {{{2 unalias

# TODO: Won't need this once we load the standard git completions.
# {{{3 gitfast

unalias g ga gaa gap gapa gau gav gb gba gbd gbD gbda gbl gbnm gbr gbs gbsb gbsg gbsr gbss gc gc! gca gca! gcam gcan! gcans! gcb gcd gcf gcl gclean gcm gcmsg gcn! gco gcount gcp gcpa gcpc gcs gcsm gd gdca gdct gdcw gds gdt gdw gf gfa gfo gg gga ggpull ggpur ggpush ggsup ghh gignore gignored git-svn-dcommit-push gk gke gl glg glgg glgga glgm glgp glo glod glods glog gloga glol glols glola glp glum gm gma gmom gmt gmtvim gmum gp gpd gpf gpf! gpoat gpristine gpsup gpu gpv gr gra grb grba grbc grbd grbi grbm grbs grh grhh grm grmc grmv groh grrm grset grt gru grup grv gsb gsd gsh gsi gsps gsr gss gst gsta gstaa gstall gstc gstd gstl gstp gsts gsu gts gtv gunignore gunwip gup gupa gupav gupv gwch gwip

# }}}3 gitfast

# {{{3 sudo

unalias _

# }}}3 sudo

# TODO: Won't need this once we don't use oh-my-zsh.
# {{{3 oh-my-zsh

unalias '...' '....' '.....' '......' 1 2 3 4 5 6 7 8 9 afind d l la ll ls lsa md rd '-'

# }}}3 oh-my-zsh

# }}}2 unalias

# }}} antigen

# vim: foldmethod=marker foldlevel=0
