# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Mise shims for every login shell, interactive or not, such as the Timi
# runner's `zsh -lc`, which never reads .zshrc.
export PATH="$HOME/.local/share/mise/shims:$PATH"

export EDITOR='hx'
export VISUAL='hx'

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

[[ -f ~/.config/secrets/env ]] && source ~/.config/secrets/env
