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

# mise shims keep managed tools available to login shells and GUI applications.
# Interactive zsh activation lives in integrations.zsh.
path=("$HOME/.local/share/mise/shims" $path)

# Global packages installed by mise-managed pnpm.
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME/bin" $path)

typeset -U path
export PATH
