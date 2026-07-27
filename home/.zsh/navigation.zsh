# directories
# Inspired by with no compdef https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/directories.zsh
#####
alias md='mkdir -p'
alias rd=rmdir

alias j=z
# Expand ... to ../.. inline (works in paths like .../script.sh)
function rationalise-dot {
  if [[ $LBUFFER == *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}

# Auto-cd when entering just a path (like ../../.., ../homespace, or /some/path)
function auto-cd-accept {
  if [[ $BUFFER =~ '^\.+(/\.+)*/?$' || -d "$BUFFER" ]]; then
    BUFFER="cd $BUFFER"
  fi
  zle accept-line
}

alias lsa='ls -lah'
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"
alias ll='ls -lh'
alias la='ls -lAh'

# Magic Enter
#############
# Empty Enter runs `l` by default, `jj st` in jj repos, and git status in git repos.
function magic-enter-cmd {
  local cmd

  if command jj root --quiet &>/dev/null; then
    zstyle -s ':zshzoo:magic-enter' jj-command 'cmd' || cmd='jj st'
  elif command git rev-parse --is-inside-work-tree &>/dev/null; then
    zstyle -s ':zshzoo:magic-enter' git-command 'cmd' || cmd='git status -sb .'
  else
    zstyle -s ':zshzoo:magic-enter' command 'cmd' || cmd='l'
  fi

  print -r -- "$cmd"
}
