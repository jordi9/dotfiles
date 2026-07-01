# Atuin: better shell history search and persistence.
# Load after Antidote/zsh-history-substring-search so Atuin's Ctrl-R and Up
# bindings win when Atuin is installed, while native history stays as fallback.
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-ai)"
fi
