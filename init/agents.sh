#!/bin/sh
# Install coding agents with their vendors' native installers.
#
# Each installer keeps the agent in its own directory and links it into
# ~/.local/bin. The agents update themselves, so this script only installs
# the ones that are missing.

set -eu

install_agent() {
  name=$1
  url=$2
  bin="$HOME/.local/bin/$name"

  if [ -x "$bin" ]; then
    echo "$name is already installed: $("$bin" --version)"
    return
  fi

  echo ">> $name"
  curl -fsSL "$url" | bash
}

install_agent claude https://claude.ai/install.sh
install_agent amp https://ampcode.com/install.sh
