#!/bin/sh
IFS='
'

formulae="
bitwarden
ferdium
font-fira-mono-nerd-font
font-jetbrains-mono-nerd-font
font-symbols-only-nerd-font
ghostty
intellij-idea
istat-menus
karabiner-elements
logi-options-plus
meetingbar
moom
orbstack
raycast
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
