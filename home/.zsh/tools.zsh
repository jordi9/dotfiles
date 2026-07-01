case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# opencode
case ":$PATH:" in
  *":$HOME/.opencode/bin:"*) ;;
  *) export PATH="$HOME/.opencode/bin:$PATH" ;;
esac

# Homebrew file(1) over macOS v5.41 — fixes MIME detection for Sony XAVC MP4s
case ":$PATH:" in
  *":/opt/homebrew/opt/file-formula/bin:"*) ;;
  *) export PATH="/opt/homebrew/opt/file-formula/bin:$PATH" ;;
esac

# Zoxide
eval "$(zoxide init zsh)"

# Helix/Zellij need COLORTERM=truecolor for correct colors.
# OpenSSH does not always forward COLORTERM, and our ssh wrapper below forces
# TERM=xterm-256color for compatibility, so restore the truecolor hint on SSH.
if [[ -n "$SSH_CONNECTION" && -z "$COLORTERM" && "$TERM" == *-256color ]]; then
  export COLORTERM=truecolor
fi

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

# Work around remote echo/input issues when SSHing from Ghostty (e.g. over Tailscale)
# by avoiding TERM=ghostty on hosts without matching terminfo, while preserving truecolor.
ssh() {
  TERM=xterm-256color COLORTERM="${COLORTERM:-truecolor}" command ssh -o SendEnv=COLORTERM "$@"
}

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac
