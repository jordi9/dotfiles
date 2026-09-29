# mise: project-aware runtime and tool versions.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Carapace: multi-shell completion engine.
# Run after completion setup so compinit/compdef are available.
function _dotfiles_configure_carapace {
  if command -v carapace >/dev/null 2>&1 && (( $+functions[compdef] )); then
    # Force colour generation for completion metadata while still letting users
    # explicitly disable it with CARAPACE_COLOR=0.
    : ${CARAPACE_COLOR:=1}
    : ${CARAPACE_ZSH_STYLE_LIMIT:=1000}
    export CARAPACE_COLOR CARAPACE_ZSH_STYLE_LIMIT

    # Optional bridges from the Carapace docs can be enabled by exporting
    # CARAPACE_BRIDGES, e.g. 'zsh,fish,bash,inshellisense'. Keep this opt-in so
    # our existing zsh completions continue to handle commands Carapace does not
    # explicitly register.
    # export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'

    source <(carapace _carapace)
  fi
}
_dotfiles_configure_carapace

# pnpm accepts `pnpm <script>` as shorthand for `pnpm run <script>`, but
# Carapace only offers package scripts for the explicit `run` form. Combine
# both candidate sets for pnpm's first argument and its local `p` alias.
function _dotfiles_pnpm_completion {
  local -a original_words=("${words[@]}")
  local original_current="$CURRENT"
  local -a words=("${original_words[@]}")
  local CURRENT="$original_current"

  words[1]=pnpm
  _carapace_completer

  if (( original_current == 2 )) && [[ "${original_words[2]}" != -* ]]; then
    words=(pnpm run "${original_words[@]:1}")
    CURRENT=$(( original_current + 1 ))
    _carapace_completer
  fi
}

function _dotfiles_configure_pnpm_completion {
  if (( $+functions[_carapace_completer] && $+functions[compdef] )); then
    compdef _dotfiles_pnpm_completion pnpm p
  fi
}
_dotfiles_configure_pnpm_completion

# `jj ws` and `jj wd` are shell helpers, not native jj subcommands. Complete
# their workspace argument here; keep Carapace for every other command/argument.
function _dotfiles_jj_completion {
  if (( CURRENT == 3 )) && [[ "${words[2]}" == (ws|wd) ]]; then
    local current_root workspace_rows name root
    local -a workspaces
    current_root="$(command jj --ignore-working-copy --no-pager workspace root 2>/dev/null)" || return 1
    workspace_rows="$(command jj --ignore-working-copy --no-pager workspace list -T 'name ++ "\t" ++ root ++ "\n"' 2>/dev/null)" || return 1
    while IFS=$'\t' read -r name root; do
      [[ -n "$name" ]] || continue
      [[ "${words[2]}" == wd && "$name" == default ]] && continue
      [[ -n "$root" && "${root:A}" == "${current_root:A}" ]] && continue
      workspaces+=("$name")
    done <<< "$workspace_rows"
    (( ${#workspaces} )) || return 1
    _describe -t workspaces 'workspaces' workspaces -Q
  else
    _carapace_completer
  fi
}

if (( $+functions[_carapace_completer] && $+functions[compdef] )); then
  compdef _dotfiles_jj_completion jj
fi

# Atuin: better shell history search and persistence.
# Load after Antidote/zsh-history-substring-search and local keybindings so
# Atuin's Ctrl-R and Up bindings win when installed, while native history stays
# as fallback.
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# Apply .envrc changes before rendering the prompt.
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Zoxide
eval "$(zoxide init zsh)"

# Enhanced zoxide completion: always use interactive picker
function _zoxide_complete_enhanced() {
  [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

  __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''
  compadd -Q ""
  \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
  \builtin printf '\e[5n'
  return 0
}
compdef _zoxide_complete_enhanced z
