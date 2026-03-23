# Exports
#########

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias cnf="vim ~/.homesick/repos/dotfiles/me.plugin.zsh"
alias zcnf="vim ~/.zshrc"
alias acnf="vim ~/.zsh/antigenrc.zsh"
alias reload='source ~/.zshrc && echo "✓ Config reloaded"'
alias redis-start="cd ~/.redis && redis-server ~/.redis/redis.conf"
# Avoid gradle or gradlew from oh-my-zsh gradle plugin
alias gradle="gradle"
alias ge="gradle-or-gradlew-quiet"
alias gw="./gradlew"
alias gen="gradle"
alias mvn="mvn"

alias fucking="sudo"
alias s="ssh"
alias j=z
alias dc="docker-compose"
alias d="docker"
alias k="kubectl"
alias hs="homeshick"
alias d-stop-all='docker stop $(docker ps -a -q)'
alias d-kill-all='docker kill $(docker ps -a -q)'
alias bluetooth-restart='blueutil -p 0 && sleep 1 && blueutil -p 1'
alias d-nuke='d-stop-all && d system prune --volumes --force'

function as {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# directories
# Inspired by with no compdef https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/directories.zsh
#####
alias md='mkdir -p'
alias rd=rmdir

# Autosuggestions keybindings
bindkey '^F' forward-word                    # Ctrl+F: accept one word

# Expand ... to ../.. inline (works in paths like .../script.sh)
function rationalise-dot {
  if [[ $LBUFFER == *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N rationalise-dot
bindkey '.' rationalise-dot
bindkey -M isearch '.' self-insert

# Auto-cd when entering just a path (like ../../.., ../homespace, or /some/path)
function auto-cd-accept {
  if [[ $BUFFER =~ '^\.+(/\.+)*/?$' || -d "$BUFFER" ]]; then
    BUFFER="cd $BUFFER"
  fi
  zle accept-line
}
zle -N auto-cd-accept
bindkey '^M' auto-cd-accept

alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# Git
#####
alias gf="git fetch"
alias gpf="gp --force-with-lease"
alias gpub='gp -u origin `g rev-parse --abbrev-ref HEAD`'
alias gri='g r -i $(git_main_branch)'

# https://stackoverflow.com/questions/20433867/git-ahead-behind-info-between-master-and-branch
alias gah='g rev-list --left-right --count $(git_main_branch)...`g rev-parse --abbrev-ref HEAD`'

alias gmdd='g log -1 --pretty=%B > commit.md'
alias gmde='code commit.md'
alias gmdc='g ci -F commit.md'
alias gmdc!='gmdc --amend'
alias glm="g log -1 --pretty=%B"
alias gd="git diff | delta --pager 'env TERM=xterm-256color less -R'"

## Optinally load extra bundles, usually private/company related
[[ -a ~/.antidote-boost ]] && source ~/.antidote-boost

function gl {
  local old_rev="$(git rev-parse HEAD)"
  git pull
  local new_rev="$(git rev-parse HEAD)"
  if [[ -n $old_rev && $old_rev != $new_rev ]]; then
    echo Updated from ${old_rev:0:7} to ${new_rev:0:7}.
    git --no-pager log --oneline --reverse --no-merges --stat '@{1}..'
  fi
}
alias gl=gl

# https://ben.lobaugh.net/blog/201616/cleanup-and-remove-all-merged-local-and-remote-git-branches
alias g-delete-merged-branches='gb --merged | grep -v "\*" | grep -v $(git_main_branch) | xargs -n 1 git branch -d && g remote prune origin'

function gh-personal-account {
  git config user.email "jordi@donky.org"
  git config user.name "Jordi Gerona"
}

# Set up .local_gitignore -> https://medium.com/@peter_graham/how-to-create-a-local-gitignore-1b19f083492b
function git-setup-local-ignore {
  #touch .local_gitignore
  echo ".local_gitignore\n" >> .local_gitignore
  echo "excludesfile = $PWD/.local_gitignore" | pbcopy
  g config --local -e
}

function gh-setup-ssh {
  ssh-add --apple-use-keychain ~/.ssh/id_github_com
}

# zsh-history-substring-search configuration
bindkey '\eOA' history-substring-search-up # or '^[[A'
bindkey '\eOB' history-substring-search-down # or '^[[B'
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

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
