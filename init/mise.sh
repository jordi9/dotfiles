#!/bin/sh
# Install the global runtimes declared in ~/.config/mise/config.toml.

set -eu

if ! command -v mise >/dev/null 2>&1; then
  echo "mise is not installed; run init/brew.sh first" >&2
  exit 1
fi

mkdir -p \
  "$HOME/.local/bin" \
  "$HOME/.local/share/go" \
  "$HOME/.cache/go-build" \
  "$HOME/.cache/go-mod"

mise install
