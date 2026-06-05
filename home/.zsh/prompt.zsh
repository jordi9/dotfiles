setopt correct

source ~/.zsh/spaceship/spaceship-gradle.plugin.zsh

export SPACESHIP_PROMPT_PREFIXES_SHOW=false
export SPACESHIP_USER_SHOW=false

export SPACESHIP_TIME_SHOW=false
export SPACESHIP_BATTERY_SHOW=false
export SPACESHIP_KUBECTL_SHOW=false
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false

# Show Jujutsu repositories with spaceship-jj. To hide git in a jj repo, use direnv:
#   echo 'export SPACESHIP_GIT_SHOW=false' > .envrc && direnv allow
# Guard prevents duplicate segments when re-sourcing ~/.zshrc.
if spaceship::defined spaceship_jj && [[ ! " ${SPACESHIP_PROMPT_ORDER[@]} " =~ " jj " ]]; then
  spaceship add --before git jj
fi

# Only add gradle segment if not already present (prevents duplication on re-sourcing)
if [[ ! " ${SPACESHIP_PROMPT_ORDER[@]} " =~ " gradle " ]]; then
  spaceship add gradle
fi


precmd() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    export SPACESHIP_PROMPT_PREFIXES_SHOW=true
    echo -ne "\e]0;${PWD##*/} @${HOST}\a"
  else
    # Local session: just show directory
    echo -ne "\e]0;${PWD##*/}\a"
  fi
}

alias show-kube-context='SPACESHIP_KUBECTL_SHOW=true'
alias hide-kube-context='SPACESHIP_KUBECTL_SHOW=false'
