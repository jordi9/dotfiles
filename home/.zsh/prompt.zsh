setopt correct

source ~/.zsh/spaceship/spaceship-gradle.plugin.zsh

export SPACESHIP_PROMPT_PREFIXES_SHOW=false
export SPACESHIP_USER_SHOW=false

export SPACESHIP_TIME_SHOW=false
export SPACESHIP_BATTERY_SHOW=false
export SPACESHIP_KUBECTL_SHOW=false
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false

# Calm Jujutsu prompt: state icon + muted truncated description/change id.
export SPACESHIP_JJ_PREFIX="on "
export SPACESHIP_JJ_SUFFIX=" "
export SPACESHIP_JJ_CLEAN_SYMBOL="󰂕 "
export SPACESHIP_JJ_DIRTY_SYMBOL="󰂔 "
export SPACESHIP_JJ_ICON_COLOR="yellow"
export SPACESHIP_JJ_DESC_COLOR="yellow"
export SPACESHIP_JJ_DESC_MAX_LENGTH=32

# Spaceship renders sections in bold by default; reset intensity inside the jj section.
SPACESHIP_JJ_NORMAL_INTENSITY=$'%{\e[22m%}'

# Override spaceship-jj to show only a calm clean/dirty icon and the change description,
# falling back to the current change id when the description is empty.
spaceship_jj() {
  [[ $SPACESHIP_JJ_SHOW == false ]] && return

  spaceship::exists jj || return
  jj root --quiet >/dev/null 2>&1 || return

  local jj_desc
  jj_desc="$(
    spaceship_jj::log @ \
      "if(description, truncate_end(${SPACESHIP_JJ_DESC_MAX_LENGTH}, description.first_line(), \"…\"), change_id.shortest(8))"
  )"

  local jj_desc_style="%F{${SPACESHIP_JJ_DESC_COLOR}}"
  local jj_symbol="$SPACESHIP_JJ_CLEAN_SYMBOL"

  if [[ -n "$(spaceship_jj::run diff -r @ --summary)" ]]; then
    jj_symbol="$SPACESHIP_JJ_DIRTY_SYMBOL"
  fi

  local jj_content="${SPACESHIP_JJ_NORMAL_INTENSITY}${jj_desc_style}${jj_desc}"

  spaceship::section::v4 \
    --color "$SPACESHIP_JJ_ICON_COLOR" \
    --prefix "$SPACESHIP_JJ_PREFIX" \
    --suffix "$SPACESHIP_JJ_SUFFIX" \
    --symbol "${SPACESHIP_JJ_NORMAL_INTENSITY}${jj_symbol}" \
    "$jj_content"
}

# Show Jujutsu repositories with spaceship-jj.
# Guard prevents duplicate segments when re-sourcing ~/.zshrc.
if spaceship::defined spaceship_jj && [[ ! " ${SPACESHIP_PROMPT_ORDER[@]} " =~ " jj " ]]; then
  spaceship add --before git jj
fi

# In jj/git-colocated repos, show the jj section and suppress Spaceship's git section
# globally instead of adding per-repo .envrc files.
export SPACESHIP_GIT_HIDE_IN_JJ="${SPACESHIP_GIT_HIDE_IN_JJ:-true}"

_dotfiles_in_jj_repo() {
  spaceship::exists jj || return 1
  jj root --quiet >/dev/null 2>&1
}

if (( $+functions[spaceship_git] && ! $+functions[_dotfiles_spaceship_git] )); then
  functions[_dotfiles_spaceship_git]=$functions[spaceship_git]

  spaceship_git() {
    [[ $SPACESHIP_GIT_HIDE_IN_JJ == true ]] && _dotfiles_in_jj_repo && return
    _dotfiles_spaceship_git "$@"
  }
fi

# Only add gradle segment if not already present (prevents duplication on re-sourcing)
if [[ ! " ${SPACESHIP_PROMPT_ORDER[@]} " =~ " gradle " ]]; then
  spaceship add gradle
fi


precmd() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    export SPACESHIP_PROMPT_PREFIXES_SHOW=true
    echo -ne "\e]0;${PWD##*/} @${HOST}\a"
  else
    # Local session: just show directory
    echo -ne "\e]0;${PWD##*/}\a"
  fi
}

alias show-kube-context='SPACESHIP_KUBECTL_SHOW=true'
alias hide-kube-context='SPACESHIP_KUBECTL_SHOW=false'
