# Exports
#########
# Cask options
export HOMEBREW_CASK_OPTS="--caskroom=/opt/apps"

# Set desired java version
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export GOPATH=~/.gopath

# The PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.bin:$GOPATH/bin

# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias zcnf="vim ~/.zshrc"
alias reload="source ~/.zshrc"
#alias mvn="mvn-color"
alias redis-start="cd ~/.redis && redis-server ~/.redis/redis.conf"
alias ge="gradle"
alias fucking="sudo"
alias gf="git fetch"
alias wr="cd ~/workspace/homeland/rtb"
alias wn="cd ~/workspace/nebraska"
alias s="ssh" 

# Mac
#####

# Reload Dock
alias reload-dock="killall Dock"

# Add a spacer to the left side of the Dock (where the applications are)
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && reload-dock"

# Misc
######

alias copy-mysql-driver="cp ~/.m2/repository/mysql/mysql-connector-java/5.1.26/mysql-connector-java-5.1.26.jar ."
alias xmas='curl climagic.org/txt/jb.txt | while read -r c n l;do printf "\e[1;${c}m%${COLUMNS}s\e[0m\n" " ";play -q -n synth pl $n trim 0 $l;done'

alias fix-htop-permissions="sudo chown root:wheel /usr/local/bin/htop && sudo chmod u+s /usr/local/bin/htop"

# Audophile
###########

function transcode () {
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
