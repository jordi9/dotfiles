# Exports
#########
# Cask options
export HOMEBREW_CASK_OPTS="--caskroom=/opt/apps"

# The PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.bin

# Set desired java version
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home

# Set locale properly
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Aliases
#########
alias homecnf="cd ~/.homesick/repos/dotfiles"
alias zcnf="vim ~/.zshrc"
alias reload="source ~/.zshrc"
#alias mvn="mvn-color"
alias redis-start="cd ~/.redis && redis-server ~/.redis/redis.conf"
alias ge="gradle"

# Mac
#####

# Reload Dock
alias reload-dock="killall Dock"

# Add a spacer to the left side of the Dock (where the applications are)
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && reload-dock"

# Misc
######

alias copy-mysql-driver="cp ~/.m2/repository/mysql/mysql-connector-java/5.1.26/mysql-connector-java-5.1.26.jar ."

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
