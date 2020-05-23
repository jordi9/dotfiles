#!/bin/sh
IFS='
'

brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts
brew tap homebrew/cask-drivers

formulae="
alfred
bartender
bettertouchtool
chatmate-for-whatsapp
dropbox
flux
font-consolas-for-powerline
font-fira-mono-for-powerline
font-inconsolata-for-powerline
font-source-code-pro-for-powerline
google-chrome-beta
google-chrome-canary
intellij-idea
istat-menus
iterm2
logitech-options
moom
roon
slack
swinsian
the-unarchiver
transmission
visual-studio-code
vlc
witch
xld
zoom
"

for f in $formulae; do
  brew cask install $f
done

# Not used now
# mou
# sourcetree
# chicken
# soulver
# typora