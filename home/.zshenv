# Keep user-installed command locations available in every zsh mode.
if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi
[[ -r "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

# SSH and persistent terminal layers do not reliably propagate COLORTERM.
# These TERM values are used by terminals in this setup that support 24-bit color.
if [[ -t 1 && -z ${COLORTERM:-} ]]; then
  case ${TERM:-} in
    xterm-ghostty|xterm-kitty|xterm-256color|screen-256color*|tmux-256color*)
      export COLORTERM=truecolor
      ;;
  esac
fi
