# Accept one word from autosuggestions. The autosuggestions setup replaces
# this fallback with its custom widget after the deferred plugin initializes.
bindkey '^F' forward-word

# Open the current command line in $VISUAL/$EDITOR.
# Save and quit the editor to return to the prompt.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line

# Expand ... to ../.. inline, while preserving normal dots during search.
zle -N rationalise-dot
bindkey '.' rationalise-dot
bindkey -M isearch '.' self-insert

# Turn a bare directory path into `cd <path>` when Enter is pressed.
zle -N auto-cd-accept
bindkey '^M' auto-cd-accept

# Search history using the current command-line prefix.
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down
