#!/bin/sh
IFS='
'

brew tap homebrew/cask-fonts

formulae="
alfred
arc
bartender
bettertouchtool
flux
ferdium
font-consolas-for-powerline
font-fira-mono-for-powerline
font-inconsolata-for-powerline
font-source-code-pro-for-powerline
intellij-idea
istat-menus
karabiner-elements
logitech-options
meetingbar
moom
roon
slack
tidal
visual-studio-code
witch
xld
zoom
"

for f in $formulae; do
  brew install --cask $f
done

# Not used now
# mou
# sourcetree
# chicken
# soulver
# typora
