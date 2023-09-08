#!/bin/sh
IFS='
'

brew tap homebrew/cask-fonts

formulae="
alfred
bartender
bettertouchtool
homebrew/cask/flux
ferdium
font-consolas-for-powerline
font-fira-mono-for-powerline
font-inconsolata-for-powerline
font-source-code-pro-for-powerline
google-chrome-beta
google-chrome-canary
intellij-idea
istat-menus
iterm2
karabiner-elements
logitech-options
moom
roon
slack
swinsian
telegram
the-unarchiver
transmission
visual-studio-code
vlc
witch
xld
zoom
"

for f in $formulae; do
  brew install --cash $f
done

# Not used now
# mou
# sourcetree
# chicken
# soulver
# typora
