#!/bin/sh
# Keep Go's workspace and caches out of ~/go on a fresh machine.
# Go itself is installed by init/brew.sh.

set -eu

if ! command -v go >/dev/null 2>&1; then
  echo "go is not installed; run init/brew.sh first" >&2
  exit 1
fi

data_home=${XDG_DATA_HOME:-"$HOME/.local/share"}
cache_home=${XDG_CACHE_HOME:-"$HOME/.cache"}
gobin="$HOME/.local/bin"
gopath="$data_home/go"
gocache="$cache_home/go-build"
gomodcache="$cache_home/go-mod"

mkdir -p "$gobin" "$gopath" "$gocache" "$gomodcache"

go env -w \
  "GOBIN=$gobin" \
  "GOCACHE=$gocache" \
  "GOMODCACHE=$gomodcache" \
  "GOPATH=$gopath"

printf 'Go environment configured:\n'
go env GOBIN GOCACHE GOMODCACHE GOPATH
