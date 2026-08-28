#!/bin/zsh
# Check or apply the personal macOS preferences used by this dotfiles setup.
# Running without arguments is read-only. Writes require --apply; erasing Dock
# application icons additionally requires --wipe-dock.

set -eu

mode=check
wipe_dock=0

usage() {
  cat <<'EOF'
Usage: init/macos.zsh [--check] [--apply [--wipe-dock]]

  --check       Report preference drift without changing anything (default).
  --apply       Apply preference changes.
  --wipe-dock   With --apply, back up the Dock domain and erase pinned apps.
EOF
}

while (( $# > 0 )); do
  case "$1" in
    --check)
      mode=check
      ;;
    --apply)
      mode=apply
      ;;
    --wipe-dock)
      wipe_dock=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      print -u2 "Unknown argument: $1"
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ $mode != apply && $wipe_dock == 1 ]]; then
  print -u2 -- '--wipe-dock requires --apply'
  exit 2
fi

changes=0
applied=0
restart_dock=0
restart_finder=0

preference() {
  local scope=$1
  local domain=$2
  local key=$3
  local type=$4
  local expected=$5
  local label=$6
  local affected_app=$7
  local current
  local -a scope_args

  scope_args=()
  [[ $scope == current-host ]] && scope_args=(-currentHost)

  if ! current=$(defaults $scope_args read "$domain" "$key" 2>/dev/null); then
    current='<unset>'
  fi

  if [[ $current == $expected ]]; then
    printf '[OK]     %s = %s\n' "$label" "$expected"
    return
  fi

  changes=$((changes + 1))
  printf '[CHANGE] %s: %s -> %s\n' "$label" "$current" "$expected"
  [[ $mode == apply ]] || return

  defaults $scope_args write "$domain" "$key" "-$type" "$expected"
  applied=$((applied + 1))
  case $affected_app in
    Dock) restart_dock=1 ;;
    Finder) restart_finder=1 ;;
  esac
}

# General UI and Spaces
preference user com.apple.dock mru-spaces bool 0 \
  'Automatically rearrange Spaces' Dock
preference user NSGlobalDomain NSWindowResizeTime float 0.001 \
  'AppKit window resize time' none
preference user NSGlobalDomain AppleScrollerPagingBehavior bool 1 \
  'Click scrollbar to jump to position' none

# Finder
preference user com.apple.finder ShowStatusBar bool 1 \
  'Finder status bar' Finder
preference user com.apple.finder ShowPathbar bool 1 \
  'Finder path bar' Finder
preference user com.apple.finder FXEnableExtensionChangeWarning bool 0 \
  'Finder extension-change warning' Finder
preference user com.apple.finder WarnOnEmptyTrash bool 0 \
  'Finder empty-trash warning' Finder

# Dock
preference user com.apple.dock tilesize int 16 'Dock tile size' Dock
preference user com.apple.dock autohide bool 1 'Dock auto-hide' Dock
preference user com.apple.dock autohide-time-modifier float 0.5 \
  'Dock auto-hide animation duration' Dock
preference user com.apple.dock autohide-delay float 0 \
  'Dock auto-hide delay' Dock
preference user com.apple.dock show-recents bool 0 \
  'Recent applications in Dock' Dock

# Hot corners: bottom-right Mission Control, top-right Desktop.
preference user com.apple.dock wvous-br-corner int 2 \
  'Bottom-right hot corner' Dock
preference user com.apple.dock wvous-br-modifier int 0 \
  'Bottom-right hot-corner modifier' Dock
preference user com.apple.dock wvous-tr-corner int 4 \
  'Top-right hot corner' Dock
preference user com.apple.dock wvous-tr-modifier int 0 \
  'Top-right hot-corner modifier' Dock

# Input and text substitutions
preference user NSGlobalDomain com.apple.swipescrolldirection bool 0 \
  'Natural scrolling' none
preference user NSGlobalDomain KeyRepeat int 2 'Keyboard repeat rate' none
preference user NSGlobalDomain InitialKeyRepeat int 25 \
  'Initial keyboard repeat delay' none
preference user NSGlobalDomain NSAutomaticDashSubstitutionEnabled bool 0 \
  'Smart dashes' none
preference user NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled bool 0 \
  'Automatic period substitution' none
preference user NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled bool 0 \
  'Smart quotes' none
preference user NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool 0 \
  'Automatic spelling correction' none

# Screen saver: never start automatically.
preference current-host com.apple.screensaver idleTime int 0 \
  'Screen saver idle time' none

pinned_apps=$(defaults read com.apple.dock persistent-apps 2>/dev/null \
  | grep -c 'tile-data' || true)
if (( pinned_apps == 0 )); then
  print '[OK]     Dock pinned applications = 0'
else
  changes=$((changes + 1))
  printf '[CHANGE] Dock pinned applications: %d -> 0\n' "$pinned_apps"

  if [[ $mode == apply && $wipe_dock == 1 ]]; then
    backup_dir="$HOME/Library/Application Support/dotfiles-backups"
    backup_file="$backup_dir/com.apple.dock-$(date +%Y%m%d-%H%M%S).plist"
    mkdir -p "$backup_dir"
    defaults export com.apple.dock "$backup_file" >/dev/null
    defaults write com.apple.dock persistent-apps -array
    applied=$((applied + 1))
    restart_dock=1
    printf '[BACKUP] Dock preferences: %s\n' "$backup_file"
  elif [[ $mode == apply ]]; then
    print '[SKIP]   Dock apps unchanged; rerun with --apply --wipe-dock'
  fi
fi

if [[ $mode == apply ]]; then
  (( restart_dock == 0 )) || killall Dock >/dev/null 2>&1 || true
  (( restart_finder == 0 )) || killall Finder >/dev/null 2>&1 || true
  printf '\nApplied %d preference change(s).\n' "$applied"
  if (( pinned_apps > 0 && wipe_dock == 0 )); then
    exit 1
  fi
  print 'Some changes may require logout or restart.'
  exit 0
fi

printf '\nFound %d preference change(s).\n' "$changes"
if (( changes > 0 )); then
  print 'Review the output, then run init/macos.zsh --apply --wipe-dock.'
  exit 1
fi
