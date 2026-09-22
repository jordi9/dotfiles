#!/bin/sh
# Install Pi and globally link JavaScript CLIs from local source checkouts.
#
# Pi stays in pnpm's global layout so `pi update` can update the executable.
# Other registry-published CLIs are declared in ~/.config/mise/config.toml;
# Pi packages/extensions are declared in ~/.pi/agent/settings.json.

set -eu

if ! command -v mise >/dev/null 2>&1; then
  echo "mise is not installed; run init/brew.sh first" >&2
  exit 1
fi

if ! mise exec -- pnpm --version >/dev/null 2>&1; then
  echo "pnpm is not installed; run init/mise.sh first" >&2
  exit 1
fi

export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
export PATH="$PNPM_HOME/bin:$PATH"
mkdir -p "$PNPM_HOME/bin"

run_pnpm() {
  mise exec -- pnpm "$@"
}

require_checkout() {
  if [ ! -f "$1/package.json" ]; then
    echo "required checkout is missing: $1" >&2
    exit 1
  fi
}

run_pnpm config set global-bin-dir "$PNPM_HOME/bin"

# Pi's updater supports pnpm globals but not mise's npm backend layout.
echo ">> @earendil-works/pi-coding-agent"
run_pnpm add -g --ignore-scripts @earendil-works/pi-coding-agent

chloe_dir=${CHLOE_DIR:-"$HOME/dev/chloe"}
pi_dac_dir=${PI_DAC_DIR:-"$HOME/dev/pi-dac"}
require_checkout "$chloe_dir"
require_checkout "$pi_dac_dir"

# These private packages link to their source checkouts. Build their untracked
# output first so the global commands work on a fresh machine.
echo ">> $chloe_dir"
run_pnpm --dir "$chloe_dir" install --frozen-lockfile
run_pnpm --dir "$chloe_dir" build
run_pnpm add -g "$chloe_dir"

echo ">> $pi_dac_dir/packages/pi-dac-mode"
run_pnpm --dir "$pi_dac_dir" install --frozen-lockfile
run_pnpm add -g "$pi_dac_dir/packages/pi-dac-mode"

echo ">> $pi_dac_dir/packages/wiim-pro"
run_pnpm --dir "$pi_dac_dir" --filter wiim-pro build
run_pnpm add -g "$pi_dac_dir/packages/wiim-pro"
