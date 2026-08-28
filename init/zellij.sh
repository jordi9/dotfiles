#!/bin/sh
# Install the pinned zjstatus plugin used by the tracked Zellij layout.

set -eu

version='0.24.0'
expected_sha256='1ccedece1ded62cf3e209be690cdd39ca6fb9e8228ed71a951f6507f9956669b'
url="https://github.com/dj95/zjstatus/releases/download/v${version}/zjstatus.wasm"
destination="$HOME/.config/zellij/plugins/zjstatus.wasm"

digest() {
  shasum -a 256 "$1" | awk '{ print $1 }'
}

case ${1:-} in
  --check)
    [ -f "$destination" ] && [ "$(digest "$destination")" = "$expected_sha256" ]
    exit
    ;;
  '') ;;
  *)
    printf 'usage: %s [--check]\n' "$0" >&2
    exit 2
    ;;
esac

if [ -f "$destination" ] && [ "$(digest "$destination")" = "$expected_sha256" ]; then
  printf 'zjstatus v%s is already installed\n' "$version"
  exit 0
fi

destination_dir=$(dirname -- "$destination")
mkdir -p "$destination_dir"
tmp_file=$(mktemp "$destination_dir/.zjstatus.XXXXXX") || exit 1
trap 'rm -f "$tmp_file"' EXIT HUP INT TERM

curl --fail --location --silent --show-error "$url" --output "$tmp_file"
actual_sha256=$(digest "$tmp_file")
if [ "$actual_sha256" != "$expected_sha256" ]; then
  printf 'zjstatus checksum mismatch: expected %s, got %s\n' \
    "$expected_sha256" "$actual_sha256" >&2
  exit 1
fi

chmod 0644 "$tmp_file"
mv "$tmp_file" "$destination"
trap - EXIT HUP INT TERM
printf 'Installed zjstatus v%s at %s\n' "$version" "$destination"
