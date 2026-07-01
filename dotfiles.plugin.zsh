# Exports
#########

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias cnf="vim ~/.homesick/repos/dotfiles/dotfiles.plugin.zsh"
alias zcnf="vim ~/.zshrc"
alias reload='source ~/.zshrc && echo "✓ Config reloaded"'

function refresh-completions {
  local zcompdump

  if zstyle -T ':zsh-utils:plugins:completion' use-xdg-basedirs; then
    zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"
    mkdir -p -- "${zcompdump:h}"
  else
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  fi

  rm -f -- "$zcompdump" "${zcompdump}.zwc"

  # compinit does not reliably replace mappings already loaded in the current
  # shell. Clear its state first so stale dump entries (for example Homebrew jj's
  # old _clap_dynamic_completer_jj mapping) cannot be written back out.
  unset _comps _services _patcomps _postpatcomps _compautos

  autoload -Uz compinit
  compinit -i -d "$zcompdump"

  # Re-apply local completion styles and Carapace's dynamic compdefs after a
  # manual refresh so the current shell matches a fresh shell.
  [[ -r "${ZDOTDIR:-$HOME}/.zsh/completion.zsh" ]] && source "${ZDOTDIR:-$HOME}/.zsh/completion.zsh"
  [[ -r "${ZDOTDIR:-$HOME}/.zsh/carapace.zsh" ]] && source "${ZDOTDIR:-$HOME}/.zsh/carapace.zsh"

  rehash
  echo "✓ Completions refreshed"
}

# Avoid gradle or gradlew from oh-my-zsh gradle plugin
alias gradle="gradle"
alias ge="gradle-or-gradlew-quiet"
alias gw="./gradlew"
alias gen="gradle"
alias mvn="mvn"
alias p="pnpm"

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

alias skills='p dlx skills'
alias dotagents='p dlx @sentry/dotagents'

alias hud='hunk diff'
alias hus='hunk show'

function jj-workspace-add {
  emulate -L zsh

  local requested_name from workspace_rows repo_root repo_name workspace_path workspace_name
  local existing_name existing_root source_workspace_name default_root repo_prefix
  local -a revision_args passthrough_args
  local custom_revision=0

  while (( $# > 0 )); do
    case "$1" in
      -h|--help)
        echo "Usage: jj wa [OPTIONS] [workspace]" >&2
        echo "" >&2
        echo "Creates a sibling workspace at <current-root>.<workspace>." >&2
        echo "The jj workspace name is <workspace>, or <current-workspace>.<workspace> when nested." >&2
        echo "" >&2
        echo "Options:" >&2
        echo "  -r, --revision <REVSET>  Parent revision for the new workspace (default: @)" >&2
        echo "  -f, --from <REVSET>      Alias for --revision" >&2
        echo "  -m, --message <MESSAGE>  Description for the new workspace commit" >&2
        echo "      --sparse-patterns <MODE>" >&2
        return 0
        ;;
      -r|--revision|-f|--from)
        if (( $# < 2 )); then
          echo "jj wa: $1 requires a value" >&2
          return 2
        fi
        if (( ! custom_revision )); then
          revision_args=()
          custom_revision=1
        fi
        revision_args+=(-r "$2")
        shift 2
        ;;
      --revision=*|--from=*)
        if (( ! custom_revision )); then
          revision_args=()
          custom_revision=1
        fi
        from="${1#*=}"
        if [[ -z "$from" ]]; then
          echo "jj wa: ${1%%=*} requires a value" >&2
          return 2
        fi
        revision_args+=(-r "$from")
        shift
        ;;
      -m|--message|--sparse-patterns)
        if (( $# < 2 )); then
          echo "jj wa: $1 requires a value" >&2
          return 2
        fi
        passthrough_args+=("$1" "$2")
        shift 2
        ;;
      --message=*|--sparse-patterns=*)
        passthrough_args+=("$1")
        shift
        ;;
      --name|--name=*)
        echo "jj wa: --name is managed by the helper; pass the workspace leaf name instead" >&2
        return 2
        ;;
      --)
        shift
        break
        ;;
      -*)
        passthrough_args+=("$1")
        shift
        ;;
      *)
        if [[ -n "$requested_name" ]]; then
          echo "Usage: jj wa [OPTIONS] [workspace]" >&2
          return 2
        fi
        requested_name="$1"
        shift
        ;;
    esac
  done

  if (( $# > 0 )); then
    if (( $# > 1 )) || [[ -n "$requested_name" ]]; then
      echo "Usage: jj wa [OPTIONS] [workspace]" >&2
      return 2
    fi
    requested_name="$1"
  fi

  if [[ -z "$requested_name" ]]; then
    if [[ ! -t 0 ]]; then
      echo "Usage: jj wa [OPTIONS] <workspace>" >&2
      echo "stdin is not a terminal, so interactive input is unavailable" >&2
      return 2
    fi
    read "requested_name?Workspace name: " || return 1
  fi

  if [[ ! "$requested_name" =~ '^[A-Za-z0-9][A-Za-z0-9._-]*$' ]]; then
    echo "jj wa: workspace name may contain only letters, numbers, dots, underscores, and hyphens, and must start with a letter or number" >&2
    return 2
  fi

  if (( ! custom_revision )); then
    revision_args=(-r @)
  fi

  repo_root="$(command jj --ignore-working-copy --no-pager workspace root)" || return $?
  repo_name="${repo_root:t}"
  workspace_path="${repo_root:h}/${repo_name}.${requested_name}"

  workspace_rows="$(command jj --ignore-working-copy --no-pager workspace list -T 'name ++ "\t" ++ root ++ "\n"')" || return $?
  while IFS=$'\t' read -r existing_name existing_root; do
    [[ -n "$existing_name" ]] || continue
    if [[ "$existing_name" == "default" ]]; then
      default_root="$existing_root"
    fi
    if [[ "$existing_root" == "$repo_root" ]]; then
      source_workspace_name="$existing_name"
    fi
  done <<< "$workspace_rows"

  workspace_name="$requested_name"
  if [[ -n "$source_workspace_name" && "$source_workspace_name" != "default" ]]; then
    if [[ -n "$default_root" ]]; then
      repo_prefix="${default_root:t}."
    fi
    if [[ -n "$repo_prefix" && "$source_workspace_name" == "$repo_prefix"* ]]; then
      source_workspace_name="${source_workspace_name#$repo_prefix}"
    fi
    workspace_name="${source_workspace_name}.${requested_name}"
  fi

  while IFS=$'\t' read -r existing_name existing_root; do
    if [[ "$existing_name" == "$workspace_name" ]]; then
      echo "jj wa: jj workspace already exists: $workspace_name" >&2
      return 1
    fi
  done <<< "$workspace_rows"

  if [[ -e "$workspace_path" ]]; then
    echo "jj wa: workspace path already exists: $workspace_path" >&2
    return 1
  fi

  echo "Creating jj workspace '$workspace_name' at $workspace_path"
  command jj workspace add "${revision_args[@]}" "${passthrough_args[@]}" --name "$workspace_name" "$workspace_path" || return $?
  echo "✓ Created jj workspace '$workspace_name' at $workspace_path"
}

function jj-workspace-delete {
  emulate -L zsh

  local workspace workspaces root physical_root current_root current_physical_root

  if (( $# > 1 )); then
    echo "Usage: jj wd [workspace]" >&2
    return 2
  fi

  if (( $# == 0 )); then
    if ! command -v fzf >/dev/null 2>&1; then
      echo "Usage: jj wd <workspace>" >&2
      echo "fzf is not installed, so interactive selection is unavailable" >&2
      return 2
    fi

    workspaces="$(command jj --ignore-working-copy --no-pager workspace list -T 'name ++ "\n"')" || return $?
    workspaces="$(printf '%s\n' "$workspaces" | grep -vxF default || true)"
    if [[ -z "$workspaces" ]]; then
      echo "No non-default workspaces to delete" >&2
      return 1
    fi

    workspace="$(
      printf '%s\n' "$workspaces" |
        fzf --height 40% \
          --prompt='jj wd> ' \
          --header='Select workspace to delete; Esc cancels' \
          --preview='jj --ignore-working-copy --no-pager workspace root --name {} 2>/dev/null'
    )" || return 0
    [[ -n "$workspace" ]] || return 0
  else
    workspace="$1"
    if [[ "$workspace" == "-h" || "$workspace" == "--help" ]]; then
      echo "Usage: jj wd [workspace]" >&2
      return 0
    fi
  fi

  if [[ "$workspace" == "default" ]]; then
    echo "Refusing to delete default workspace" >&2
    return 1
  fi

  root="$(command jj workspace root --name "$workspace")" || return $?
  physical_root="$(cd "$root" && pwd -P)" || return $?

  if [[ -z "$physical_root" || "$physical_root" == "/" || "$physical_root" == "$HOME" || ! -e "$physical_root/.jj" ]]; then
    echo "Refusing to delete suspicious workspace root: $physical_root" >&2
    return 1
  fi

  current_root="$(command jj --ignore-working-copy --no-pager workspace root 2>/dev/null)" || current_root=""
  if [[ -n "$current_root" ]]; then
    current_physical_root="$(cd "$current_root" && pwd -P)" || current_physical_root=""
    if [[ "$physical_root" == "$current_physical_root" ]]; then
      echo "Refusing to delete the current workspace; switch to another workspace first" >&2
      return 1
    fi
  fi

  if ! command rm -rf -- "$physical_root"; then
    echo "jj wd: failed to remove $physical_root; workspace '$workspace' was not forgotten" >&2
    return 1
  fi

  if [[ -e "$physical_root" ]]; then
    echo "jj wd: failed to remove $physical_root completely; workspace '$workspace' was not forgotten" >&2
    return 1
  fi

  if ! command jj workspace forget -- "$workspace"; then
    echo "jj wd: removed $physical_root, but failed to forget jj workspace '$workspace'" >&2
    echo "jj wd: run 'jj workspace forget -- \"$workspace\"' after resolving the error" >&2
    return 1
  fi

  echo "✓ Deleted workspace '$workspace' at $physical_root"
}

function jj-workspace-switch {
  emulate -L zsh

  local selection workspace workspace_root

  if (( $# > 1 )); then
    echo "Usage: jj ws [workspace]" >&2
    return 2
  fi

  if (( $# == 1 )); then
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: jj ws [workspace]" >&2
      return 0
    fi
    workspace="$1"
  else
    if ! command -v fzf >/dev/null 2>&1; then
      echo "Usage: jj ws <workspace>" >&2
      echo "fzf is not installed, so interactive selection is unavailable" >&2
      return 2
    fi

    selection="$(
      command jj --color=always workspace list |
        fzf --ansi --height 40% \
          --delimiter=':' \
          --prompt='jj ws> ' \
          --header='Select workspace to switch to; Esc cancels' \
          --preview='jj --ignore-working-copy --no-pager workspace root --name {1} 2>/dev/null'
    )" || return 0
    [[ -n "$selection" ]] || return 0

    workspace="${selection%%:*}"
  fi

  [[ -n "$workspace" ]] || return 0
  workspace_root="$(command jj workspace root --name "$workspace")" || return $?
  [[ -n "$workspace_root" ]] || return 0
  builtin cd -- "$workspace_root"
}

# Intercept `jj ws` as a zsh function so switching can cd the current shell.
# All other jj invocations go to the real jj binary.
function jj {
  if [[ "$1" == "ws" ]]; then
    shift
    jj-workspace-switch "$@"
  else
    command jj "$@"
  fi
}

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
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"
alias ll='ls -lh'
alias la='ls -lAh'

# Magic Enter
#############
# Empty Enter runs `l` by default, `jj st` in jj repos, and git status in git repos.
function magic-enter-cmd {
  local cmd

  if command jj root --quiet &>/dev/null; then
    zstyle -s ':zshzoo:magic-enter' jj-command 'cmd' || cmd='jj st'
  elif command git rev-parse --is-inside-work-tree &>/dev/null; then
    zstyle -s ':zshzoo:magic-enter' git-command 'cmd' || cmd='git status -sb .'
  else
    zstyle -s ':zshzoo:magic-enter' command 'cmd' || cmd='l'
  fi

  print -r -- "$cmd"
}

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

# Native zsh history fallback. Atuin is sourced later when installed, but keep
# plain zsh history useful on machines that do not have Atuin yet.
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY

# zsh-history-substring-search configuration
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down
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
