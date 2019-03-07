#!/bin/sh
IFS='
'
# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

formulae="
git
git-recent
htop
wget
pv
tree
mysql
ack
autojump
watch
gettext
vim --override-system-vi
grep
screen
"
for f in $formulae; do
  brew install $f
done

# Audiophile
#brew install sox --with-flac

# Nerdy 
# Advent calendar http://www.qemu-advent-calendar.org/
#brew install qemu
