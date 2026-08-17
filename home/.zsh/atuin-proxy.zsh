# Start Atuin's PTY proxy before loading the rest of the shell configuration.
# The proxy replaces this shell and starts zsh again.
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin pty-proxy init zsh)"
fi
