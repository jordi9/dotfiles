#!/bin/sh
IFS='
'
# Make sure we're using the latest Homebrew
brew update

formulae="
ack
antidote
bat
bitwarden-cli
btop
coreutils
fd
ffmpeg
gh
git
git-cliff
git-delta
git-recent
glow
grep
helix
helmfile
homeshick
htop
jq
k9s
kubectx
pv
rclone
ripgrep
screen
stern
tailscale
tree
vim
watch
wget
yazi
zellij
zoxide
zsh
"
for f in $formulae; do
  echo ">> $f"
  brew install $f
done
