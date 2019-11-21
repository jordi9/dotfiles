#!/bin/sh
IFS='
'

brew tap homebrew/cask-fonts

formulae="
alfred
adium
google-chrome-beta
dropbox
evernote
skitch
java
radiant-player
moom
witch
flux
iterm2
the-unarchiver
swinsian
intellij-idea
bettertouchtool
music-manager
xld
caffeine
adobe-reader
transmission
android-file-transfer
vlc
disk-inventory-x
istat-menus
bartender
sonos
slack
atom
google-photos-backup
google-chrome-canary
music-manager
spotify
soulver
kindle
typora
visual-studio-code
font-fira-mono-for-powerline
"

for f in $formulae; do
  brew cask install $f
done

# Not used now
# mou
# sourcetree
# chicken
