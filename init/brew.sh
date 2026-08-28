#!/bin/sh
# Install the Homebrew formulae and casks declared in the repository Brewfile.

set -eu

CDPATH=''
export CDPATH
repo_root=$(cd -- "$(dirname -- "$0")/.." && pwd)
exec brew bundle install --no-upgrade --file="$repo_root/Brewfile"
