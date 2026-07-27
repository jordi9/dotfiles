#!/bin/zsh

# Using high-performance install from https://antidote.sh/install

# Set the root name of the public plugins files (.txt and .zsh) Antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
antidote_home="$(brew --prefix)"/opt/antidote/share/antidote

# Source zstyles you might use with Antidote.
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

# Install Antidote if necessary.
[[ -d $antidote_home ]] ||
  brew install antidote

# Lazy-load Antidote from its functions directory.
fpath=($antidote_home/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever the public manifest is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle < ${zsh_plugins}.txt 2>/dev/null >| ${zsh_plugins}.zsh
fi

# Source the public static plugins file.
source ${zsh_plugins}.zsh
