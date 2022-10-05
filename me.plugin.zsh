# Exports
#########

# Set desired java version
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home
#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export KAFKA_HOME=$HOME/.bin/kafka_2.12-2.2.0

export PATH=/usr/local/opt/gettext/bin:$PATH:$KAFKA_HOME/bin

# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias cnf="vim ~/.homesick/repos/dotfiles/me.plugin.zsh"
alias zcnf="vim ~/.zshrc"
alias acnf="vim ~/.zsh/antigenrc.zsh"
alias reload="source ~/.zshrc"
alias redis-start="cd ~/.redis && redis-server ~/.redis/redis.conf"
# Avoid stupid gradle or gradlew from oh-my-zsh gradle plugin
alias gradle="gradle"
alias ge="gradle-or-gradlew"
alias gen="gradle"
alias mvn="mvn"

alias fucking="sudo"
alias s="ssh"
alias dc="docker-compose"
alias d="docker"
alias hs="homesick"
alias d-stop-all='docker stop $(docker ps -a -q)'
alias d-kill-all='docker kill $(docker ps -a -q)'
alias bluetooth-restart='blueutil -p 0 && sleep 1 && blueutil -p 1'
alias d-nuke='d-stop-all && d system prune --volumes --force'

# Git
#####
alias gf="git fetch"
alias gpf="gp --force-with-lease"
alias gpub='gp -u origin `g rev-parse --abbrev-ref HEAD`'
alias gri="g r -i master"

# https://stackoverflow.com/questions/20433867/git-ahead-behind-info-between-master-and-branch
alias gah='g rev-list --left-right --count master...`g rev-parse --abbrev-ref HEAD`'

# commit.md | Set up .local_gitignore -> https://medium.com/@peter_graham/how-to-create-a-local-gitignore-1b19f083492b
alias gmdd='g log -1 --pretty=%B > commit.md'
alias gmde='code commit.md'
alias gmdc='g ci -F commit.md'
alias gmdc!='gmdc --amend'

function gl {
  local old_rev="$(git rev-parse HEAD)"
  git pull
  local new_rev="$(git rev-parse HEAD)"
  if [[ -n $old_rev && $old_rev != $new_rev ]]; then
    echo Updated from ${old_rev:0:7} to ${new_rev:0:7}.
    git --no-pager log --oneline --reverse --no-merges --stat '@{1}..'
  fi
}
alias gl=gl

# https://ben.lobaugh.net/blog/201616/cleanup-and-remove-all-merged-local-and-remote-git-branches
alias g-delete-merged-branches="gb --merged | grep -v '\*' | grep -v master | xargs -n 1 git branch -d && g remote prune origin"

# Gradle
#####

function gradle-create-subproject {
  local name=$1
  mkdir "$name"
  mkdir -p "$name"/src/test/kotlin
  mkdir -p "$name"/src/main/kotlin
  touch "$name/$name".gradle.kts
  echo "include(\"$name\")" | pbcopy
  echo "include string ready to be pasted in settings.gradle"
}

# Mac
#####

# Reload Dock
alias reload-dock="killall Dock"

# Add a spacer to the left side of the Dock (where the applications are)
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}' && reload-dock"

# Do not disturb, stop bouncing
alias do-not-disturb="defaults write com.apple.dock no-bouncing -bool TRUE && reload-dock"
alias disturb="defaults write com.apple.dock no-bouncing -bool FALSE && reload-dock"

## High Sierra dark mode for mojave https://www.tekrevue.com/tip/only-dark-menu-bar-dock-mojave/
# System Preferences > General and select Light for Appearance
alias high-sierra-dark-on="defaults write -g NSRequiresAquaSystemAppearance -bool Yes"
# Logout. System Preferences > General and select Dark for Appearance
alias high-sierra-dark-off="defaults delete -g NSRequiresAquaSystemAppearance"

# Always use the integrated graphics card while running on battery power
alias graphics-integrated="sudo pmset -b gpuswitch 0"

# Always use the discrete graphics card while running on battery power
alias graphics-discrete="sudo pmset -b gpuswitch 1"

# Switch between discrete and integrated graphics cards automatically while running on battery power
alias graphics-auto="sudo pmset -b gpuswitch 2"

# Brew
#######

function cask-install {
  COMMAND=(brew cask install $1)
  if $COMMAND; then
    print $COMMAND >> ~/.homesick/repos/dotfiles/Caskfile
    print "👌 Saved in Caskfile"
  fi
}

# https://www.client9.com/using-macos-homebrew-to-install-a-specific-version/
function brew-versions-search {
  formula=$1
  git -C "$(brew --repo homebrew/core)" log master -- Formula/$formula.rb
}

function brew-versions-install {
  brewurl=https://raw.githubusercontent.com/Homebrew/homebrew-core
  formula=$1
  sha=$2
  brew install ${BREWURL}/$sha/Formula/$formula.rb
}


# Linux
#######

alias x='xclip -selection clipboard'

# Misc
######

alias copy-mysql-driver="cp ~/.m2/repository/mysql/mysql-connector-java/5.1.26/mysql-connector-java-5.1.26.jar ."
alias xmas='curl climagic.org/txt/jb.txt | while read -r c n l;do printf "\e[1;${c}m%${COLUMNS}s\e[0m\n" " ";play -q -n synth pl $n trim 0 $l;done'

alias fix-htop-permissions="sudo chown root:wheel /usr/local/bin/htop && sudo chmod u+s /usr/local/bin/htop"

# Audophile
###########

function transcode {
  echo 'Transcoding FLAC files to 16-bit'
  mkdir resampled # make a subdirectory to put our files in

  for file in *.flac
    do
      newfile=`echo "$file" | sed "s/ /_/g"`
      mv "$file" "$newfile" # get rid of filename spaces to avoid errors
      sox -S $newfile -b 16 -r 44100 "resampled/$newfile" # resample
      mv "$newfile" "$file" # put stuff back the way we found it
    done
}
