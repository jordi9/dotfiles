#!/bin/sh
# Remove runtime managers replaced by mise on an existing machine.
# Running without arguments is read-only. Deletion requires --apply.

set -eu

mode=check

usage() {
  cat <<'EOF'
Usage: init/cleanup-legacy.sh [--check | --apply]

  --check   Show legacy runtime state without changing it (default).
  --apply   Remove SDKMAN and standalone Bun, then clear old Go env entries.

npm, pnpm, and Gradle caches are not touched.
EOF
}

case ${1:-} in
  ''|--check) ;;
  --apply) mode=apply ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    printf 'Unknown argument: %s\n' "$1" >&2
    usage >&2
    exit 2
    ;;
esac

if [ "$#" -gt 1 ]; then
  usage >&2
  exit 2
fi

case ${HOME:-} in
  /)
    echo 'Refusing to run with root as HOME' >&2
    exit 1
    ;;
  /*) ;;
  *)
    echo 'Refusing to run without an absolute HOME path' >&2
    exit 1
    ;;
esac

if ! command -v mise >/dev/null 2>&1; then
  echo 'mise is unavailable; install and verify it before cleanup' >&2
  exit 1
fi

required_tools='java ruby go node bun gradle pnpm'
missing_tools=''
for tool in $required_tools; do
  if ! MISE_AUTO_INSTALL=false mise which "$tool" >/dev/null 2>&1; then
    missing_tools="$missing_tools $tool"
  fi
done
if [ -n "$missing_tools" ]; then
  printf 'Refusing cleanup; mise does not resolve:%s\n' "$missing_tools" >&2
  exit 1
fi
printf '[OK]     mise resolves all replacement runtimes\n'

legacy_paths="$HOME/.sdkman
$HOME/.bun"
printf '%s\n' "$legacy_paths" | while IFS= read -r path; do
  if [ -e "$path" ] || [ -L "$path" ]; then
    size=$(du -sh "$path" 2>/dev/null | awk '{ print $1 }')
    printf '[REMOVE] %s%s%s\n' "$path" "${size:+ (}" "${size:+$size)}"
  else
    printf '[OK]     %s is absent\n' "$path"
  fi
done

# Ask the mise-managed Go for its persistent environment file. Disable all
# automatic installation so check mode cannot change the machine.
go_env_file=$(MISE_AUTO_INSTALL=false MISE_EXEC_AUTO_INSTALL=false \
  mise exec --no-deps -- go env GOENV 2>/dev/null || true)

go_keys='GOBIN GOCACHE GOMODCACHE GOPATH'
persisted_keys=''
if [ -n "$go_env_file" ] && [ -f "$go_env_file" ]; then
  for key in $go_keys; do
    if grep -q "^${key}=" "$go_env_file"; then
      persisted_keys="$persisted_keys $key"
    fi
  done
fi

if [ -n "$persisted_keys" ]; then
  printf '[REMOVE] Persisted Go settings:%s\n' "$persisted_keys"
else
  printf '[OK]     No replaced Go settings are persisted\n'
fi

if [ "$mode" = check ]; then
  printf '\nCheck only. Run init/cleanup-legacy.sh --apply to remove this state.\n'
  exit 0
fi

if [ -n "$persisted_keys" ]; then
  for key in $persisted_keys; do
    GOENV="$go_env_file" MISE_AUTO_INSTALL=false MISE_EXEC_AUTO_INSTALL=false \
      mise exec --no-deps -- go env -u "$key"
  done
  [ ! -f "$go_env_file" ] || [ -s "$go_env_file" ] || rm -f "$go_env_file"
fi

printf '%s\n' "$legacy_paths" | while IFS= read -r path; do
  if [ -e "$path" ] || [ -L "$path" ]; then
    rm -rf -- "$path"
    printf '[REMOVED] %s\n' "$path"
  fi
done

printf '\nLegacy runtime cleanup complete. Active caches were left alone.\n'
printf 'Run: exec zsh\n'
printf 'Then rerun init/doctor.sh.\n'
