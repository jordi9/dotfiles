# Exports
#########
# Cask options
export HOMEBREW_CASK_OPTS="--caskroom=/opt/apps"

# Set desired java version
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias cnf="vim ~/.homesick/repos/dotfiles/plugins/me/me.plugin.zsh"
alias zcnf="vim ~/.zshrc"
alias reload="source ~/.zshrc"
#alias mvn="mvn-color"
alias redis-start="cd ~/.redis && redis-server ~/.redis/redis.conf"
alias ge="gradle"
alias fucking="sudo"
alias wr="cd ~/workspace/homeland/rtb"
alias wn="cd ~/workspace/nebraska"
alias wb="cd ~/workspace/rtb-board"
alias s="ssh"

# Git
#####
alias gf="git fetch"

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
alias g-delete-merged-branches="git branch --merged | grep -v "\*" | grep -v master | xargs -n 1 git branch -d"


# Mac
#####

# Reload Dock
alias reload-dock="killall Dock"

# Add a spacer to the left side of the Dock (where the applications are)
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && reload-dock"

# Do not disturb, stop bouncing
alias do-not-disturb="defaults write com.apple.dock no-bouncing -bool TRUE && reload-dock"
alias disturb="defaults write com.apple.dock no-bouncing -bool FALSE && reload-dock"


function cask-install {
  COMMAND=(brew cask install $1)
  if $COMMAND; then
    print $COMMAND >> ~/.homesick/repos/dotfiles/Caskfile
    print "👌 Saved in Caskfile"
  fi
}

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
