#!/bin/sh
# Install the global runtimes and CLI tools declared in mise config, then Vite+.

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

# Vite+ uses the mise-managed Node.js and pnpm. integrations.zsh already sources
# its env file, so stop the installer from appending to the linked zsh profiles.
# Skip an existing install; `vp upgrade` updates it.
if [ -x "$HOME/.local/share/vite-plus/current/bin/vp" ]; then
  echo "Vite+ is already installed"
else
  installer=$(mktemp)
  trap 'rm -f "$installer"' EXIT
  curl -fsSL https://vite.plus -o "$installer"
  VP_NODE_MANAGER=no VP_PM_MANAGER=no VP_SELF_SETUP_NO_MODIFY_PATH=1 \
    mise exec -- bash "$installer"
fi
