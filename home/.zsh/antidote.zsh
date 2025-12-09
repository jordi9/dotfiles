#!/bin/zsh

# Using High peformance install from https://antidote.sh/install

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
antidote_home="$(brew --prefix)"/opt/antidote/share/antidote

# Source zstyles you might use with antidote.
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

# Install antidote if necessary
[[ -d $antidote_home ]] ||
  brew install antidote

# Lazy-load antidote from its functions directory.
fpath=($antidote_home/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt or .zsh_plugins.local.txt is updated.
zsh_plugins_local=${ZDOTDIR:-~}/.zsh_plugins.local.txt

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]] ||
   [[ -f $zsh_plugins_local && ! ${zsh_plugins}.zsh -nt $zsh_plugins_local ]]; then
  cat ${zsh_plugins}.txt ${zsh_plugins_local} 2>/dev/null | antidote bundle 2>/dev/null >| ${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh

