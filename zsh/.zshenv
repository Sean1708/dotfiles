export ADOTDIR="$HOME/.local/share/antigen"

# system specific zsh config goes in .zsh/profile
if [[ -f "$HOME/.zsh/profile" ]]
then
  source "$HOME/.zsh/profile"
fi

# config compatible with bash and zsh
if [[ -f "$HOME/.sh/profile" ]]
then
    source "$HOME/.sh/profile"
fi

# load up antigen
if [[ -f "$HOME/.zsh/antigen/antigen.zsh" ]]
then
    source "$HOME/.zsh/antigen/antigen.zsh"
fi
