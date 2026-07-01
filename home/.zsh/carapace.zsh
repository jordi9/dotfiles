# Carapace: multi-shell completion engine.
# Loaded after Antidote's completion setup so compinit/compdef are available.
if command -v carapace >/dev/null 2>&1 && (( $+functions[compdef] )); then
  # Force colour generation for completion metadata while still letting users
  # explicitly disable it with CARAPACE_COLOR=0.
  : ${CARAPACE_COLOR:=1}
  : ${CARAPACE_ZSH_STYLE_LIMIT:=1000}
  export CARAPACE_COLOR CARAPACE_ZSH_STYLE_LIMIT

  # Optional bridges from the Carapace docs can be enabled by exporting
  # CARAPACE_BRIDGES, e.g. 'zsh,fish,bash,inshellisense'. Keep this opt-in so
  # our existing zsh completions continue to handle commands Carapace does not
  # explicitly register.
  # export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'

  source <(carapace _carapace)
fi
