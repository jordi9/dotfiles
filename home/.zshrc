source ~/.homesick/repos/dotfiles/antigen/antigen.zsh

export SPACESHIP_TIME_SHOW=true

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle git-extras
antigen bundle heroku
antigen bundle lein
antigen bundle command-not-found
antigen bundle mvn

# My custom plugins and shortcuts
antigen bundle $HOME/.homesick/repos/dotfiles/plugins/me --no-local-clone

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

# Load the theme.
# Theme I like: fox
#antigen theme $HOME/.homesick/repos/dotfiles themes/in-fino-veritas --no-local-clone
antigen theme denysdovhan/spaceship-zsh-theme spaceship

# Tell antigen that you're done.
antigen apply

export SDKMAN_DIR="/Users/jordi9/.sdkman"
[[ -s "/Users/jordi9/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jordi9/.sdkman/bin/sdkman-init.sh"
