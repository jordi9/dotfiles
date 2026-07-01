# Local completion presentation.
# Antidote's zsh-utils completion plugin runs compinit before this file is sourced.

# Required for menu selection and coloured completion lists.
zmodload -i zsh/complist 2>/dev/null || true

# Keep command-position completion (e.g. `gi<Tab>`) on zsh's native completer,
# but make it visually consistent with Carapace's grouped output.
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:messages' format $'\e[2;37m%d\e[m'
zstyle ':completion:*:warnings' format $'\e[0;33mNo matches found: %d\e[m'

# Use the same LS_COLORS palette for native zsh file/path completions that
# Carapace uses for styled file values. zsh-utils/coreutils already provides
# LS_COLORS on systems with GNU dircolors.
if [[ -n "${LS_COLORS:-}" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi
