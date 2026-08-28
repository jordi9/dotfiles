#!/bin/sh
# Read-only checks for a usable dotfiles installation on macOS.

set -u

failures=0
warnings=0

ok() {
  printf '[OK]   %s\n' "$1"
}

warn() {
  warnings=$((warnings + 1))
  printf '[WARN] %s\n' "$1"
}

fail() {
  failures=$((failures + 1))
  printf '[FAIL] %s\n' "$1"
}

join_lines() {
  paste -sd, - | sed 's/,/, /g'
}

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH='' cd -- "$script_dir/.." && pwd)
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-doctor.XXXXXX") || exit 1
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

export PATH="$HOME/.local/bin:$HOME/Library/pnpm/bin:$HOME/.local/share/mise/shims:$PATH"

printf 'Dotfiles doctor\n\n'

if command -v brew >/dev/null 2>&1; then
  ok "Homebrew is available"

  if HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --file="$repo_root/Brewfile" \
    | LC_ALL=C sort -u > "$tmp_dir/expected-formulae" && \
    brew list --formula | LC_ALL=C sort -u > "$tmp_dir/installed-formulae"; then
    comm -23 "$tmp_dir/expected-formulae" "$tmp_dir/installed-formulae" > "$tmp_dir/missing-formulae"
    if [ -s "$tmp_dir/missing-formulae" ]; then
      fail "Missing Homebrew formulae: $(join_lines < "$tmp_dir/missing-formulae")"
    else
      ok "All Brewfile formulae are installed"
    fi
  else
    fail "Could not inspect Brewfile formulae"
  fi

  if HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --cask --file="$repo_root/Brewfile" \
    | LC_ALL=C sort -u > "$tmp_dir/expected-casks" && \
    brew list --cask | LC_ALL=C sort -u > "$tmp_dir/installed-casks"; then
    comm -23 "$tmp_dir/expected-casks" "$tmp_dir/installed-casks" > "$tmp_dir/missing-casks"
    if [ -s "$tmp_dir/missing-casks" ]; then
      fail "Missing Homebrew casks: $(join_lines < "$tmp_dir/missing-casks")"
    else
      ok "All Brewfile casks are installed"
    fi
  else
    fail "Could not inspect Brewfile casks"
  fi
else
  fail "Homebrew is unavailable"
fi

mise_config="$HOME/.config/mise/config.toml"
if command -v mise >/dev/null 2>&1 && [ -f "$mise_config" ]; then
  ok "mise and its global config are available"

  tools=$(awk '
    /^\[tools\]$/ { in_tools = 1; next }
    /^\[/ { in_tools = 0 }
    in_tools && /^[[:alnum:]_-]+[[:space:]]*=/ {
      name = $0
      sub(/[[:space:]]*=.*/, "", name)
      print name
    }
  ' "$mise_config")

  missing_tools=''
  for tool in $tools; do
    if ! MISE_AUTO_INSTALL=false mise which "$tool" >/dev/null 2>&1; then
      missing_tools="$missing_tools $tool"
    fi
  done

  if [ -n "$missing_tools" ]; then
    fail "Missing mise tools:${missing_tools}"
  else
    ok "All configured mise tools resolve"
  fi

  expected_go_env="$HOME/.local/bin
$HOME/.cache/go-build
$HOME/.cache/go-mod
$HOME/.local/share/go"
  actual_go_env=$(MISE_AUTO_INSTALL=false MISE_EXEC_AUTO_INSTALL=false \
    mise exec --no-deps -- go env GOBIN GOCACHE GOMODCACHE GOPATH 2>/dev/null || true)
  if [ "$actual_go_env" = "$expected_go_env" ]; then
    ok "Go workspace and cache paths match the mise config"
  else
    fail "Go workspace or cache paths do not match the mise config"
  fi
else
  fail "mise or $mise_config is unavailable"
fi

required_commands='pi agent-browser hunk hunkdiff slop-scan wrangler termctrl chloe pi-dac wiim-pro'
missing_commands=''
for command_name in $required_commands; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    missing_commands="$missing_commands $command_name"
  fi
done
if [ -n "$missing_commands" ]; then
  fail "Missing global commands:${missing_commands}"
else
  ok "All selected global JavaScript commands resolve"
fi

dotfiles_castle="$HOME/.homesick/repos/dotfiles"
if [ -d "$dotfiles_castle" ]; then
  ok "The dotfiles Homeshick castle is present"
else
  fail "The dotfiles Homeshick castle is missing"
fi

check_link() {
  live=$1
  source=$2
  label=$3
  if [ -e "$live" ] && [ "$live" -ef "$source" ]; then
    ok "$label is linked"
  else
    fail "$label is not linked from the dotfiles castle"
  fi
}

check_link "$HOME/.zshrc" "$repo_root/home/.zshrc" ".zshrc"
check_link "$HOME/.zprofile" "$repo_root/home/.zprofile" ".zprofile"
check_link "$mise_config" "$repo_root/home/.config/mise/config.toml" "mise config"
check_link "$HOME/.pi/agent/settings.json" "$repo_root/home/.pi/agent/settings.json" "Pi settings"

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  ok "GitHub CLI authentication works"
else
  fail "GitHub CLI authentication is unavailable"
fi

if "$repo_root/init/zellij.sh" --check; then
  ok "The pinned Zellij zjstatus plugin is installed"
else
  fail "The pinned Zellij zjstatus plugin is missing or has the wrong checksum"
fi

if find "$HOME/Library/Fonts" /Library/Fonts -maxdepth 2 -iname '*MonoLisa*' -print -quit 2>/dev/null \
  | grep -q .; then
  ok "MonoLisa font is installed"
else
  warn "MonoLisa font was not found"
fi

zsh_syntax_ok=1
for zsh_file in "$repo_root/home/.zprofile" "$repo_root/home/.zshrc" "$repo_root"/home/.zsh/*.zsh; do
  if ! zsh -n "$zsh_file"; then
    zsh_syntax_ok=0
  fi
done
if [ "$zsh_syntax_ok" -eq 1 ]; then
  ok "Tracked Zsh configuration parses"
else
  fail "Tracked Zsh configuration has a syntax error"
fi

if (cd "$dotfiles_castle" && jj root >/dev/null 2>&1); then
  if [ -n "$(cd "$dotfiles_castle" && jj diff --summary 2>/dev/null)" ]; then
    warn "The dotfiles castle has uncommitted changes"
  fi
  unpublished_stack=$(cd "$dotfiles_castle" && \
    jj log -r '(::@- ~ ::main) & ~empty()' --no-graph -T 'commit_id.short()' 2>/dev/null || true)
  if [ -n "$unpublished_stack" ]; then
    warn "The current dotfiles stack has non-empty ancestors outside main"
  fi
  unpublished_main=$(cd "$dotfiles_castle" && \
    jj log -r 'main@origin..main' --no-graph -T 'commit_id.short()' 2>/dev/null || true)
  if [ -n "$unpublished_main" ]; then
    warn "The dotfiles main bookmark has commits not present on its last-fetched origin/main"
  fi
fi

warn "Verify Accessibility, Screen Recording, and login-item permissions manually"

printf '\nDoctor finished with %d failure(s) and %d warning(s).\n' "$failures" "$warnings"
[ "$failures" -eq 0 ]
