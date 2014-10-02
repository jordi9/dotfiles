# https://github.com/blinks zsh theme

# This theme works with both the "dark" and "light" variants of the
# Solarized color schema.  Set the SOLARIZED_THEME variable to one of
# these two values to choose.  If you don't specify, we'll assume you're
# using the "dark" variant.

case ${SOLARIZED_THEME:-dark} in
    light) bkg=white;;
    *)     bkg=black;;
esac

ZSH_THEME_GIT_PROMPT_PREFIX=" git:%{%B%F{blue}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ☁"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# use $(git_prompt_status) to show this

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[yellow]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[magenta]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%} ✭"

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='%{%f%k%b%}
%{%K{${bkg}}%}@%{%B%F{red}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{${bkg}}%}%~%{%B%F{green}%}$(git_prompt_info)%E%{%f%k%b%}
${ret_status} % %{$reset_color%}'

## PROMPT with local username
#PROMPT='%{%f%k%b%}
#%{%K{${bkg}}%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{${bkg}}%}%~%{%B%F{green}%}$(git_prompt_info)%E%{%f%k%b%}
#${ret_status} % %{$reset_color%}'


RPROMPT='%{%F{cyan}%}%D{[%H:%M:%S]}'


