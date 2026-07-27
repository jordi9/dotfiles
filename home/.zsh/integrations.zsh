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

# Atuin: better shell history search and persistence.
# Load after Antidote/zsh-history-substring-search and local keybindings so
# Atuin's Ctrl-R and Up bindings win when installed, while native history stays
# as fallback.
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-ai)"
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
