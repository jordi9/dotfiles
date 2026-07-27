# General command shortcuts
alias dc="docker-compose"
alias d="docker"
alias k="kubectl"
alias hs="homeshick"
alias d-stop-all='docker stop $(docker ps -a -q)'
alias d-kill-all='docker kill $(docker ps -a -q)'
alias d-nuke='d-stop-all && d system prune --volumes --force'

alias skills='p dlx skills'

alias hu='hunk'
alias hud='hunk diff'
alias hus='hunk show'

function as {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# Avoid gradle or gradlew from oh-my-zsh gradle plugin
alias gradle="gradle"
alias ge="gradle-or-gradlew-quiet"
alias gw="./gradlew"
alias gen="gradle"
alias mvn="mvn"
alias p="pnpm"

# Gradle
#####

function gradle-create-subproject {
  local name=$1
  mkdir "$name"
  mkdir -p "$name"/src/test/kotlin
  mkdir -p "$name"/src/main/kotlin
  touch "$name/build.gradle.kts"
  echo "include(\"$name\")" | pbcopy
  echo "include string ready to be pasted in settings.gradle"
}

# Looks for a gradlew-quiet or gradlew file in the current working directory
# or any of its parent directories, and executes it if found.
# Otherwise it will call gradle directly.
function gradle-or-gradlew-quiet() {
  # find project root
  # taken from https://github.com/gradle/gradle-completion
  local dir="$PWD" project_root="$PWD"
  while [[ "$dir" != / ]]; do
    if [[ -x "$dir/gradlew" ]]; then
      project_root="$dir"
      break
    fi
    dir="${dir:h}"
  done

# prefer gradlew-quiet if it exists, otherwise gradlew, otherwise gradle
  if [[ -x "$project_root/gradlew-quiet" ]]; then
    echo "⚡ Running gradlew-quiet"
    "$project_root/gradlew-quiet" "$@"
  elif [[ -f "$project_root/gradlew" ]]; then
    echo "🔨 Running gradlew"
    "$project_root/gradlew" "$@"
  else
    command gradle "$@"
  fi
}

# IntelliJ IDEA
#####

# https://www.jetbrains.com/help/idea/working-with-the-ide-features-from-command-line.html
function idea {
  open -na "IntelliJ IDEA.app" --args "$@"
}

# Mac
#####

# Reload Dock
alias reload-dock="killall Dock"

# Add a spacer to the left side of the Dock (where the applications are)
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && reload-dock"

# Do not disturb, stop bouncing
alias do-not-disturb="defaults write com.apple.dock no-bouncing -bool TRUE && reload-dock"
alias disturb="defaults write com.apple.dock no-bouncing -bool FALSE && reload-dock"

alias bluetooth-restart='blueutil -p 0 && sleep 1 && blueutil -p 1'

# Linux
#######

alias x='xclip -selection clipboard'

# Misc
######

alias xmas='curl climagic.org/txt/jb.txt | while read -r c n l;do printf "\e[1;${c}m%${COLUMNS}s\e[0m\n" " ";play -q -n synth pl $n trim 0 $l;done'

alias fix-htop-permissions="sudo chown root:wheel /usr/local/bin/htop && sudo chmod u+s /usr/local/bin/htop"

function mkfile {
  mkdir -p -- "$1" && touch -- "$1"/"$2"
}


# SD Card import (Sony cameras: PRIVATE/M4ROOT/CLIP/)
# Renames files to <timestamp>_<original> (e.g. 2025-01-15_14-30_C0001.MP4)
function sdimport {
  local dest="${1:?Usage: sdimport <destination>}"
  local clip_dir="/Volumes/J9V/PRIVATE/M4ROOT/CLIP"

  if [[ ! -d "$clip_dir" ]]; then
    echo "SD card not found at $clip_dir — is it mounted?" >&2
    return 1
  fi

  local files=("$clip_dir"/*.(MP4|MXF|mp4|mxf)(N))
  files=(${files:#**/._*})

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "No video files found in $clip_dir" >&2
    return 1
  fi

  echo "Found ${#files[@]} video files → $dest"
  mkdir -p "$dest"

  local copied=0
  for f in "${files[@]}"; do
    local name="${f:t}"
    local ts=$(stat -f '%Sm' -t '%Y-%m-%d_%H-%M' "$f")
    local newname="${ts}_${name}"

    if [[ -f "$dest/$newname" ]]; then
      echo "⏭ Skipping $newname (already exists)"
    else
      rsync -ah --progress "$f" "$dest/$newname"
      ((copied++))
    fi
  done

  echo "✓ Import complete ($copied files copied)"
}

alias sdeject="diskutil eject /Volumes/J9V"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
