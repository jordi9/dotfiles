# zsh-autosuggestions configuration.
#
# Antidote loads zsh-autosuggestions with zsh-defer, so this file defines our
# local widget now and queues the final binding until after the plugin loads.

# Keep ghost suggestions visibly muted and use a 256-colour value instead of a
# theme-dependent ANSI colour or a hex colour.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

function _dotfiles_autosuggest_accept_word() {
  emulate -L zsh

  # If autosuggestions is not active, keep Ctrl+F as a normal forward-word.
  if [[ -z "${POSTDISPLAY-}" ]] ||
     (( ! $+functions[_zsh_autosuggest_highlight_reset] )) ||
     (( ! $+functions[_zsh_autosuggest_highlight_apply] )); then
    zle forward-word
    return $?
  fi

  local original_buffer="$BUFFER"
  local full_buffer="$BUFFER$POSTDISPLAY"
  local autosuggest_postdisplay
  local -i retval cursor_loc

  _zsh_autosuggest_highlight_reset 2>/dev/null

  BUFFER="$full_buffer"
  POSTDISPLAY=
  CURSOR=$#original_buffer

  # Use the builtin widget directly. Calling the wrapped forward-word lets
  # fast-syntax-highlighting colour the whole temporary buffer, which makes the
  # unaccepted ghost tail look like normal input.
  zle .forward-word
  retval=$?

  cursor_loc=$CURSOR
  if [[ "$KEYMAP" = "vicmd" ]]; then
    cursor_loc=$((cursor_loc + 1))
  fi

  if (( cursor_loc > $#original_buffer )); then
    POSTDISPLAY="${BUFFER[$((cursor_loc + 1)),$#BUFFER]}"
    BUFFER="${BUFFER[1,$cursor_loc]}"
    CURSOR=$#BUFFER
  else
    BUFFER="$original_buffer"
    CURSOR=$#BUFFER
  fi

  # Re-highlight only the accepted buffer, then let autosuggestions paint the
  # remaining POSTDISPLAY. This keeps the accepted part normal while preserving
  # a dim ghost tail.
  if (( $+functions[_zsh_highlight] )); then
    autosuggest_postdisplay="$POSTDISPLAY"
    POSTDISPLAY=
    _zsh_highlight 2>/dev/null
    POSTDISPLAY="$autosuggest_postdisplay"
  fi

  _zsh_autosuggest_highlight_apply 2>/dev/null
  zle -R
  return $retval
}

function _dotfiles_configure_autosuggestions() {
  # Wait until zsh-autosuggestions has initialized its default widget lists.
  (( ${+ZSH_AUTOSUGGEST_IGNORE_WIDGETS} )) || return 0

  if [[ -z ${ZSH_AUTOSUGGEST_IGNORE_WIDGETS[(r)dotfiles-autosuggest-accept-word]} ]]; then
    ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=('dotfiles-autosuggest-accept-word')
  fi

  zle -N dotfiles-autosuggest-accept-word _dotfiles_autosuggest_accept_word
  bindkey '^F' dotfiles-autosuggest-accept-word
}

# Configure immediately on reloads, and queue configuration after deferred
# plugin loading for fresh shells.
_dotfiles_configure_autosuggestions
if (( $+functions[zsh-defer] )); then
  zsh-defer _dotfiles_configure_autosuggestions
fi
