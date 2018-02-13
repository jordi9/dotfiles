source ~/.homesick/repos/dotfiles/antigen/antigen.zsh


# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
#antigen bundle git-extras
antigen bundle lein
antigen bundle command-not-found
#antigen bundle mvn
antigen bundle gradle

# My custom plugins and shortcuts
antigen bundle $HOME/.homesick/repos/dotfiles/plugins/me --no-local-clone
antigen bundle $HOME/.homesick/repos/private-home/plugins/zopa --no-local-clone

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

# Load the theme.
# Theme I like: fox
#antigen theme $HOME/.homesick/repos/dotfiles themes/in-fino-veritas --no-local-clone
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_BATTERY_SHOW=false
export SPACESHIP_KUBECONTEXT_SHOW=false
antigen theme denysdovhan/spaceship-zsh-theme spaceship

# Tell antigen that you're done.
antigen apply

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/zopadev/.sdkman"
[[ -s "/home/zopadev/.sdkman/bin/sdkman-init.sh" ]] && source "/home/zopadev/.sdkman/bin/sdkman-init.sh"
