#!/bin/zsh

# Generate and source machine-specific plugins after the personal modules.
zsh_plugins_local=${ZDOTDIR:-~}/.zsh_plugins.local

if [[ -f ${zsh_plugins_local}.txt ]]; then
  if [[ ! ${zsh_plugins_local}.zsh -nt ${zsh_plugins_local}.txt ]]; then
    antidote bundle < ${zsh_plugins_local}.txt 2>/dev/null >| ${zsh_plugins_local}.zsh
  fi

  source ${zsh_plugins_local}.zsh
fi

# Load arbitrary machine-specific configuration after private plugins.
[[ -r "${ZDOTDIR:-$HOME}/.zshrc.local" ]] &&
  source "${ZDOTDIR:-$HOME}/.zshrc.local"
