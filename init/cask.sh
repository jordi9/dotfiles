#!/bin/sh
IFS='
'

formulae="
alfred
arc
bettertouchtool
ferdium
font-consolas-for-powerline
font-fira-mono-for-powerline
font-inconsolata-for-powerline
font-source-code-pro-for-powerline
intellij-idea
istat-menus
karabiner-elements
logi-options-plus
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
