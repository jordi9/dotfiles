#!/bin/sh
# Install global JavaScript CLIs with pnpm.
#
# Pi packages/extensions are declared in ~/.pi/agent/settings.json so pi can
# install/manage them itself; don't duplicate those package installs here.

set -e

# Script-local setup only; persistent shell PATH lives in home/.zsh/tools.zsh.
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
export PATH="$PNPM_HOME/bin:$PATH"
mkdir -p "$PNPM_HOME/bin"

if ! command -v pnpm >/dev/null 2>&1; then
  if ! command -v corepack >/dev/null 2>&1; then
    npm install -g corepack
  fi

  corepack enable
  corepack prepare pnpm@latest --activate
fi

pnpm config set global-bin-dir "$PNPM_HOME/bin"

packages="
@earendil-works/pi-coding-agent
@google/gemini-cli
@playwright/mcp
@sentry/warden
chloe
hunkdiff
slop-scan
typescript
wrangler
"

for p in $packages; do
  echo ">> $p"
  case "$p" in
    @earendil-works/pi-coding-agent)
      pnpm add -g --ignore-scripts "$p"
      ;;
    *)
      pnpm add -g "$p"
      ;;
  esac
done
