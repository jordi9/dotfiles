# Start Atuin's PTY proxy before loading the rest of the shell configuration.
# The proxy replaces this shell and starts zsh again.
if command -v atuin >/dev/null 2>&1; then
  _dotfiles_init_atuin_pty_proxy() {
    # SSH login shells use "-zsh" as argv[0]. Atuin strips the dash and would
    # pass the resulting bare "zsh" to its PTY layer, which expects a path.
    local proxy_shell="${ZSH_ARGZERO#-}"
    [[ -n "$proxy_shell" ]] || proxy_shell=zsh
    if [[ "$proxy_shell" != */* ]]; then
      proxy_shell="$(command -v -- "$proxy_shell")"
    fi

    local ZSH_ARGZERO="$proxy_shell"
    eval "$(atuin pty-proxy init zsh)"
  }

  _dotfiles_init_atuin_pty_proxy
  unfunction _dotfiles_init_atuin_pty_proxy
fi
