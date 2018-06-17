GIT_ADDED='✚'  # \u271a
GIT_MODIFIED='✹'  # \u2739
GIT_DELETED='✖'  # \u2716
GIT_RENAMED='→'  # \u2192
GIT_UNMERGED='≠'  # \u2260
GIT_UNTRACKED='★'  # \u2605
MY_JOBS='⚙'  # \u2699
MY_ROOT='⚡'  # \u26a1
MY_RETURN='↵'  # \u21b5
MY_USER='≫'  # \u226b

prompt_thematique_colour() {
	if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]
	then
		print -n "%{$fg[$1]%}$2%{$reset_color%}"
	else
		print -n "$2"
	fi
}

prompt_thematique_open() {
	prompt_thematique_colour gray '['
}

prompt_thematique_separate() {
	prompt_thematique_colour gray ' | '
}

prompt_thematique_close() {
	prompt_thematique_colour gray ']'
}

prompt_thematique_start() {
	print
	if [[ $UID -eq 0 ]]
	then
		prompt_thematique_colour yellow "$MY_ROOT "
	else
		prompt_thematique_colour gray "$MY_USER "
	fi
}

prompt_thematique_user_info() {
	prompt_thematique_colour red '%n'
	prompt_thematique_colour gray '@'
	prompt_thematique_colour magenta '%m'
	prompt_thematique_colour gray ':'
	prompt_thematique_colour blue '%~'
}

prompt_thematique_git_info() {
	# TODO: Redo this using vcs_info.
	ZSH_THEME_GIT_PROMPT_PREFIX=" | git:%{$fg[green]%}"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DIRTY=""
	ZSH_THEME_GIT_PROMPT_CLEAN=""

	ZSH_THEME_GIT_PROMPT_ADDED="$(prompt_thematique_colour green "$GIT_ADDED")"
	ZSH_THEME_GIT_PROMPT_MODIFIED="$(prompt_thematique_colour blue "$GIT_MODIFIED")"
	ZSH_THEME_GIT_PROMPT_DELETED="$(prompt_thematique_colour red "$GIT_DELETED")"
	ZSH_THEME_GIT_PROMPT_RENAMED="$(prompt_thematique_colour mag "$GIT_RENAMED")"
	ZSH_THEME_GIT_PROMPT_UNMERGED="$(prompt_thematique_colour yel "$GIT_UNMERGED")"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="$(prompt_thematique_colour cya "$GIT_UNTRACKED")"

	print -n "$(git_prompt_info)$(git_prompt_status)"
}

prompt_thematique_return_info() {
	if [[ "$RETVAL" -gt 0 ]]
	then
		prompt_thematique_separate
		prompt_thematique_colour red "$MY_RETURN $RETVAL"
	fi
}

prompt_thematique_job_info() {
	local num_jobs="$(jobs | wc -l)"
	if [[ "$num_jobs" -gt 0 ]]
	then
		prompt_thematique_separate
		prompt_thematique_colour blue "$MY_JOBS $num_jobs"
	fi
}

prompt_thematique_main() {
	RETVAL=$?

	prompt_thematique_open

	prompt_thematique_user_info
	prompt_thematique_git_info
	prompt_thematique_return_info
	prompt_thematique_job_info

	prompt_thematique_close
	prompt_thematique_start
}

prompt_thematique_precmd() {
	PROMPT='$(prompt_thematique_main)'
}

prompt_thematique_setup() {
	autoload -Uz add-zsh-hook

	prompt_opts=(cr subst percent)

	add-zsh-hook precmd prompt_thematique_precmd
}

prompt_thematique_setup "$@"
