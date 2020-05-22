#!/bin/sh
IFS='
'
# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

formulae="
ack
autojump
bat
gettext
git
git-recent
grep
htop
pv
rbenv
ruby-build
screen
stern
tree
vim
watch
wget
"
for f in $formulae; do
  echo ">> $f"
  brew install $f
done

# Audiophile
#brew install sox --with-flac

# Nerdy 
# Advent calendar http://www.qemu-advent-calendar.org/
#brew install qemu
