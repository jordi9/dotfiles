#!/bin/sh
IFS='
'
# Make sure we’re using the latest Homebrew
brew update

brew tap heroku/brew

formulae="
ack
autojump
bat
btop
gettext
git
git-recent
grep
heroku
htop
jq
kubectx
kubernetes-cli
k9s
pv
screen
stern
tree
vim
watch
wget
zsh
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
