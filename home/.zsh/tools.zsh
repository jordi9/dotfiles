# Claude Code
export PATH="$HOME/.local/bin:$PATH"

# Zoxide
eval "$(zoxide init zsh)"

# Enhanced zoxide completion: always use interactive picker
function _zoxide_complete_enhanced() {
    [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

    __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''
    compadd -Q ""
    \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
    \builtin printf '\e[5n'
    return 0
}
compdef _zoxide_complete_enhanced z

# SDKMAN (must be last)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
