# Exports
#########
# Cask options
export HOMEBREW_CASK_OPTS="--caskroom=/opt/apps"

# The PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/bin

# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias zcnf="vim ~/.zshrc"
alias reload="source ~/.zshrc"
alias mvn="mvn-color"

# Mac
#####

# Reload Dock
alias reload-dock="killall Dock"

# Add a spacer to the left side of the Dock (where the applications are)
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && reload-dock"


