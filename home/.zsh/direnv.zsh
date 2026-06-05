# Keep this before Spaceship prompt setup so .envrc changes are applied before rendering.
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
