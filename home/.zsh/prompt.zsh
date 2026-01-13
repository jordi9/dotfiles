setopt correct

source ~/.zsh/spaceship/spaceship-gradle.plugin.zsh

export SPACESHIP_PROMPT_PREFIXES_SHOW=false
export SPACESHIP_TIME_SHOW=false
export SPACESHIP_BATTERY_SHOW=false
export SPACESHIP_KUBECTL_SHOW=false
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false

# Only add gradle segment if not already present (prevents duplication on re-sourcing)
if [[ ! " ${SPACESHIP_PROMPT_ORDER[@]} " =~ " gradle " ]]; then
  spaceship add gradle
fi


precmd() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    # In SSH session: show directory and hostname
    echo -ne "\e]0;${PWD##*/} - SSH: ${HOST}\a"
  else
    # Local session: just show directory
    echo -ne "\e]0;${PWD##*/}\a"
  fi
}

alias show-kube-context='SPACESHIP_KUBECTL_SHOW=true'
alias hide-kube-context='SPACESHIP_KUBECTL_SHOW=false'
