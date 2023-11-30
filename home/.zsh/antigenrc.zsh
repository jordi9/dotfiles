# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# See prompt.zsh for config
antigen theme spaceship-prompt/spaceship-prompt

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundles <<EOBUNDLES
git
autojump
gradle
mvn
ssh-agent

Tarrasch/zsh-autoenv
paulirish/git-open
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
zsh-users/zsh-autosuggestions

# My custom plugins and shortcuts
$HOME/.homesick/repos/dotfiles --no-local-clone
EOBUNDLES

# tmp until https://github.com/spaceship-prompt/spaceship-gradle/pull/2 gets merged
#spaceship-prompt/spaceship-gradle --branch=main

## Optinally load extra bundles, usually private/company related
[[ -a ~/.antigenextra ]] && source ~/.antigenextra

## THEME
# Theme I like: fox
# antigen theme $HOME/.homesick/repos/dotfiles themes/in-fino-veritas --no-local-clone


# Pure https://github.com/sindresorhus/pure
# antigen bundle mafredri/zsh-async
# antigen bundle sindresorhus/pure

# Tell antigen that you're done.
antigen apply