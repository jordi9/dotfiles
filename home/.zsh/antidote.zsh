#!/bin/zsh

# Zsh options
setopt extended_glob

# Source zstyles you might use with antidote.
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

antidote_home="$(brew --prefix)"/opt/antidote/share/antidote

# Install antidote if necessary
[[ -d $antidote_home ]] ||
  brew install antidote

source $antidote_home/antidote.zsh

antidote load

# need to run compinit again to make zsh-z work, even when zsh-utils runs it before
compinit

## Optinally load extra bundles, usually private/company related
[[ -a ~/.antidote-boost ]] && source ~/.antidote-boost
