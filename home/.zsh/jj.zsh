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

function _jj-open-web-url {
  emulate -L zsh

  local git_url="$1" protocol="https" git_protocol uri domain url_path

  if [[ "$git_url" == *://* ]]; then
    git_protocol="${git_url%%://*}"
    uri="${git_url#*://}"
    uri="${uri#*@}"
    domain="${uri%%/*}"
    url_path="${uri#*/}"

    if [[ "$git_protocol" == "http" || "$git_protocol" == "https" ]]; then
      protocol="$git_protocol"
    else
      domain="${domain%%:*}"
    fi
  elif [[ "$git_url" == *:* && "$git_url" != /* ]]; then
    uri="${git_url##*@}"
    domain="${uri%%:*}"
    url_path="${uri#*:}"
  else
    echo "jj open: unsupported remote URL: $git_url" >&2
    return 1
  fi

  url_path="${url_path#/}"
  url_path="${url_path%/}"
  url_path="${url_path%.git}"

  if [[ -z "$domain" || -z "$url_path" || "$url_path" == "$uri" ]]; then
    echo "jj open: unsupported remote URL: $git_url" >&2
    return 1
  fi

  print -r -- "$protocol://$domain/$url_path"
}

function jj-open {
  emulate -L zsh

  local print_only=0 requested_remote remote_rows remote_name remote_url name url rest repo_url suffix
  local -a suffix_parts opener

  while (( $# > 0 )); do
    case "$1" in
      -h|--help)
        echo "Usage: jj open [-p|--print] [remote] [--suffix path]" >&2
        echo "" >&2
        echo "Opens the web URL for a jj repo's Git remote (origin by default)." >&2
        return 0
        ;;
      -p|--print)
        print_only=1
        shift
        ;;
      -s|--suffix)
        if (( $# < 2 )); then
          echo "jj open: $1 requires a value" >&2
          return 2
        fi
        suffix_parts+=("$2")
        shift 2
        ;;
      --suffix=*)
        suffix_parts+=("${1#*=}")
        shift
        ;;
      --)
        shift
        break
        ;;
      -*)
        echo "jj open: unknown option: $1" >&2
        return 2
        ;;
      *)
        if [[ -n "$requested_remote" ]]; then
          echo "Usage: jj open [-p|--print] [remote] [--suffix path]" >&2
          return 2
        fi
        requested_remote="$1"
        shift
        ;;
    esac
  done

  if (( $# > 0 )); then
    suffix_parts+=("$@")
  fi

  if ! command jj root --quiet &>/dev/null; then
    echo "jj open: not in a jj repository" >&2
    return 1
  fi

  remote_rows="$(command jj --ignore-working-copy --no-pager --color never git remote list)" || return $?
  if [[ -z "$remote_rows" ]]; then
    echo "jj open: no Git remotes configured" >&2
    return 1
  fi

  while read -r name url rest; do
    [[ -n "$name" && -n "$url" ]] || continue

    if [[ -n "$requested_remote" ]]; then
      if [[ "$name" == "$requested_remote" ]]; then
        remote_name="$name"
        remote_url="$url"
        break
      fi
    elif [[ "$name" == "origin" ]]; then
      remote_name="$name"
      remote_url="$url"
      break
    elif [[ -z "$remote_url" ]]; then
      remote_name="$name"
      remote_url="$url"
    fi
  done <<< "$remote_rows"

  if [[ -z "$remote_url" ]]; then
    if [[ -n "$requested_remote" ]]; then
      echo "jj open: remote not found: $requested_remote" >&2
    else
      echo "jj open: no usable Git remotes configured" >&2
    fi
    return 1
  fi

  repo_url="$(_jj-open-web-url "$remote_url")" || return $?

  for suffix in "${suffix_parts[@]}"; do
    [[ -n "$suffix" ]] || continue
    suffix="${suffix#/}"
    repo_url="${repo_url%/}/$suffix"
  done

  if (( print_only )); then
    print -r -- "$repo_url"
    return 0
  fi

  if [[ -n "$BROWSER" ]]; then
    if [[ -x "$BROWSER" ]] || command -v -- "$BROWSER" >/dev/null 2>&1; then
      command "$BROWSER" "$repo_url"
      return $?
    fi
  fi

  case "$(uname -s)" in
    Darwin) opener=(open) ;;
    MINGW*|MSYS*) opener=(start) ;;
    CYGWIN*) opener=(cygstart) ;;
    *)
      if uname -r | grep -qi Microsoft; then
        opener=(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile Start)
      else
        opener=(xdg-open)
      fi
      ;;
  esac

  command "${opener[@]}" "$repo_url"
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
