# Exports
#########

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias cnf="vim ~/.homesick/repos/dotfiles/me.plugin.zsh"
alias zcnf="vim ~/.zshrc"
alias acnf="vim ~/.zsh/antigenrc.zsh"
alias reload="omz reload"
alias redis-start="cd ~/.redis && redis-server ~/.redis/redis.conf"
# Avoid gradle or gradlew from oh-my-zsh gradle plugin
alias gradle="gradle"
alias ge="gradle-or-gradlew"
alias gen="gradle"
alias mvn="mvn"

alias fucking="sudo"
alias s="ssh"
alias j=z
alias dc="docker-compose"
alias d="docker"
alias k="kubectl"
alias hs="homeshick"
alias d-stop-all='docker stop $(docker ps -a -q)'
alias d-kill-all='docker kill $(docker ps -a -q)'
alias bluetooth-restart='blueutil -p 0 && sleep 1 && blueutil -p 1'
alias d-nuke='d-stop-all && d system prune --volumes --force'


# directories
# Inspired by with no compdef https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/directories.zsh
#####
alias md='mkdir -p'
alias rd=rmdir

alias ..='up 1'
alias ...='up 2'
alias ....='up 3'
alias .....='up 4'
alias ......='up 5'

alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# Git
#####
alias gf="git fetch"
alias gpf="gp --force-with-lease"
alias gpub='gp -u origin `g rev-parse --abbrev-ref HEAD`'
alias gri='g r -i $(git_main_branch)'

# https://stackoverflow.com/questions/20433867/git-ahead-behind-info-between-master-and-branch
alias gah='g rev-list --left-right --count $(git_main_branch)...`g rev-parse --abbrev-ref HEAD`'

alias gmdd='g log -1 --pretty=%B > commit.md'
alias gmde='code commit.md'
alias gmdc='g ci -F commit.md'
alias gmdc!='gmdc --amend'

## Optinally load extra bundles, usually private/company related
[[ -a ~/.antidote-boost ]] && source ~/.antidote-boost

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
alias g-delete-merged-branches='gb --merged | grep -v "\*" | grep -v $(git_main_branch) | xargs -n 1 git branch -d && g remote prune origin'

function gh-personal-account {
  git config user.email "jordi@donky.org"
  git config user.name "Jordi Gerona"
}

# Set up .local_gitignore -> https://medium.com/@peter_graham/how-to-create-a-local-gitignore-1b19f083492b
function git-setup-local-ignore {
  #touch .local_gitignore
  echo ".local_gitignore\n" >> .local_gitignore
  echo "excludesfile = $PWD/.local_gitignore" | pbcopy
  g config --local -e
}

function gh-setup-ssh {
  ssh-add --apple-use-keychain ~/.ssh/id_github_com
}

# zsh-history-substring-search configuration
bindkey '\eOA' history-substring-search-up # or '^[[A'
bindkey '\eOB' history-substring-search-down # or '^[[B'
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Gradle
#####

function gradle-create-subproject {
  local name=$1
  mkdir "$name"
  mkdir -p "$name"/src/test/kotlin
  mkdir -p "$name"/src/main/kotlin
  touch "$name/build.gradle.kts"
  echo "include(\"$name\")" | pbcopy
  echo "include string ready to be pasted in settings.gradle"
}

# IntelliJ IDEA
#####

# https://www.jetbrains.com/help/idea/working-with-the-ide-features-from-command-line.html
function idea {
  open -na "IntelliJ IDEA.app" --args "$@"
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

# Brew
#######

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

alias xmas='curl climagic.org/txt/jb.txt | while read -r c n l;do printf "\e[1;${c}m%${COLUMNS}s\e[0m\n" " ";play -q -n synth pl $n trim 0 $l;done'

alias fix-htop-permissions="sudo chown root:wheel /usr/local/bin/htop && sudo chmod u+s /usr/local/bin/htop"

function mkfile { 
  mkdir -p -- "$1" && touch -- "$1"/"$2" 
}


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
