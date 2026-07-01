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
carapace
coreutils
direnv
eza
fd
ffmpeg
ffmpegthumbnailer
file-formula
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
imagemagick
jj
jq
k9s
ktlint
kubectx
kubernetes-cli
ltex-ls
media-info
mpv
pandoc
poppler
pv
rclone
resvg
ripgrep
rsync
screen
sevenzip
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
