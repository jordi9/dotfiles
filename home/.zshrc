source ~/.homesick/repos/dotfiles/antigen/antigen.zsh


# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh)

antigen bundles <<EOBUNDLES

git
# git-extras
lein
command-not-found
autojump

gradle

# My custom plugins and shortcuts
$HOME/.homesick/repos/dotfiles/plugins/me --no-local-clone
$HOME/.homesick/repos/private-home/plugins/zopa --no-local-clone

# Syntax highlighting bundle.
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search

# Fish-like autosuggestions for zsh
zsh-users/zsh-autosuggestions

EOBUNDLES

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
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
