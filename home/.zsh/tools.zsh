# Claude Code
export PATH="$HOME/.local/bin:$PATH"

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

# Handles echo issues with Ghostty/Tailscale and changes the background
ssh() {
  local saved_bg saved_title
  # Query current background (response: ^[]11;rgb:1a1a/1b1b/2626)
  exec {tty}<>/dev/tty
  printf '\e]11;?\e\\' >&$tty
  read -rs -d '\\' saved_bg <&$tty
  exec {tty}>&-

  # Extract just the color part (rgb:xxxx/xxxx/xxxx)
  saved_bg="${saved_bg##*;}"

  # Set title and background for SSH session
  printf '\e]11;#242e2c\a'  # Subtle lighter teal
  TERM=xterm-256color command ssh "$@"
  printf '\e]11;%s\a' "$saved_bg"  # Restore background
}

# SDKMAN (must be last)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
