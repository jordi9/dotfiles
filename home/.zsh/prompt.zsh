setopt correct

export SPACESHIP_TIME_SHOW=true
export SPACESHIP_BATTERY_SHOW=false
export SPACESHIP_KUBECONTEXT_SHOW=false
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_GRADLE_JVM_SHOW=false

alias show-kube-context='SPACESHIP_KUBECONTEXT_SHOW=true'
alias hide-kube-context='SPACESHIP_KUBECONTEXT_SHOW=false'