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
alias glm="g log -1 --pretty=%B"
alias gd="git diff | delta --pager 'env TERM=xterm-256color less -R'"

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
