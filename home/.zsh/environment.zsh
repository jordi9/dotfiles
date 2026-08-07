# Agent Browser
export AGENT_BROWSER_SCREENSHOT_DIR=".browser-screenshots"

# User-local tool paths.
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

# Helix/Zellij need COLORTERM=truecolor for correct colors.
# OpenSSH does not always forward COLORTERM, and our ssh wrapper below forces
# TERM=xterm-256color for compatibility, so restore the truecolor hint on SSH.
if [[ -n "$SSH_CONNECTION" && -z "$COLORTERM" && "$TERM" == *-256color ]]; then
  export COLORTERM=truecolor
fi

# Work around remote echo/input issues when SSHing from Ghostty (e.g. over Tailscale)
# by avoiding TERM=ghostty on hosts without matching terminfo, while preserving truecolor.
ssh() {
  TERM=xterm-256color COLORTERM="${COLORTERM:-truecolor}" command ssh -o SendEnv=COLORTERM "$@"
}

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME/bin" "$PNPM_HOME" $path)
typeset -U path
export PATH
# pnpm end
