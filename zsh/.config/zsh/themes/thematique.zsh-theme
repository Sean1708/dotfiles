# TODO: structure things more like https://gist.github.com/agnoster/3712874
if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]
then
    info='[%{$fg[red]%}%n%{$reset_color%}@%{$fg[magenta]%}%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)]'

    if [[ $UID -eq 0 ]]
    then
        myprompt='%{$fg[yellow]%}⚡%{$reset_color%} '
    else
        myprompt='» '
    fi

    PROMPT="$info
$myprompt"

    ZSH_THEME_GIT_PROMPT_PREFIX=" | git:%{$fg[green]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%{$fg[red]%}%? ↵ %{$reset_color%})"

    # display number of running jobs
    # running_jobs="$([[ $(jobs | wc -l) -gt 0 ]] && echo \"%{$fg[blue]%}$(jobs | wc -l) ⚙\")"

    RPROMPT='${return_code}${running_jobs}$(git_prompt_status)'

    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭%{$reset_color%}"
else
    PROMPT='[%n@%m:%~$(git_prompt_info)]
» '

    ZSH_THEME_GIT_PROMPT_PREFIX=" | git:"
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # display exitcode on the right when >0
    return_code="%(?..%? ↵ )"

    RPROMPT='${return_code}$(git_prompt_status)'

    ZSH_THEME_GIT_PROMPT_ADDED="✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="✹"
    ZSH_THEME_GIT_PROMPT_DELETED="✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="✭"
fi
