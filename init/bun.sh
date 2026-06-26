#!/bin/sh
# Install bun. Global bun packages are not tracked here because none are
# currently installed.

set -e

if command -v bun >/dev/null 2>&1; then
  echo "bun already installed: $(bun --version)"
  exit 0
fi

curl -fsSL https://bun.sh/install | bash
