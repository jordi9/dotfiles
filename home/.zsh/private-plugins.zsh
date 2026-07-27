#!/bin/zsh

# Generate and source private/company plugins independently so they load after
# the personal modules and can override their definitions.
zsh_plugins_local=${ZDOTDIR:-~}/.zsh_plugins.local

if [[ -f ${zsh_plugins_local}.txt ]]; then
  if [[ ! ${zsh_plugins_local}.zsh -nt ${zsh_plugins_local}.txt ]]; then
    antidote bundle < ${zsh_plugins_local}.txt 2>/dev/null >| ${zsh_plugins_local}.zsh
  fi

  source ${zsh_plugins_local}.zsh
fi

