# Exports
#########

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Offer corrections for mistyped commands.
setopt correct

# Shell configuration helpers
#############################
alias dot='builtin cd ~/.homesick/repos/dotfiles'
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
  if (( $+functions[_dotfiles_configure_carapace] )); then
    _dotfiles_configure_carapace
  fi

  rehash
  echo "✓ Completions refreshed"
}

# Native zsh history fallback. Atuin is sourced later when installed, but keep
# plain zsh history useful on machines that do not have Atuin yet.
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY

# zsh-history-substring-search configuration
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
