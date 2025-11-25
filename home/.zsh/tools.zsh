# Claude Code
export PATH="$HOME/.local/bin:$PATH"

# Zoxide
eval "$(zoxide init zsh)"

# SDKMAN (must be last)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
