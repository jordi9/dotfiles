# General Spaceship settings
############################
export SPACESHIP_PROMPT_PREFIXES_SHOW=false
export SPACESHIP_USER_SHOW=false

export SPACESHIP_TIME_SHOW=false
export SPACESHIP_BATTERY_SHOW=false
export SPACESHIP_KUBECTL_SHOW=false
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false

# Gradle section
################
SPACESHIP_GRADLE_SHOW="${SPACESHIP_GRADLE_SHOW=true}"
SPACESHIP_GRADLE_ASYNC="${SPACESHIP_GRADLE_ASYNC=true}"
SPACESHIP_GRADLE_PREFIX="${SPACESHIP_GRADLE_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_GRADLE_SUFFIX="${SPACESHIP_GRADLE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_GRADLE_SYMBOL=" "
SPACESHIP_GRADLE_DEFAULT_VERSION="${SPACESHIP_GRADLE_DEFAULT_VERSION=""}"
SPACESHIP_GRADLE_EXECUTE_WRAPPER="${SPACESHIP_GRADLE_EXECUTE_WRAPPER=false}"
SPACESHIP_GRADLE_COLOR="${SPACESHIP_GRADLE_COLOR="green"}"

spaceship::gradle::find_root_project() {
  local root="$1"

  if [[ -n "$SPACESHIP_GRADLE_PROJECT_ROOT" ]] && \
     [[ -f "$SPACESHIP_GRADLE_PROJECT_ROOT/settings.gradle" || \
        -f "$SPACESHIP_GRADLE_PROJECT_ROOT/settings.gradle.kts" ]]; then
    print -r -- "$SPACESHIP_GRADLE_PROJECT_ROOT"
    return
  fi

  while [ "$root" ] && \
        [ ! -f "$root/settings.gradle" ] && \
        [ ! -f "$root/settings.gradle.kts" ]; do
    root="${root%/*}"
  done

  print "$root"
}

spaceship::gradle::wrapper_version() {
  local gradle_root_dir="$1" wrapper_properties distribution_url gradle_version

  wrapper_properties="$gradle_root_dir/gradle/wrapper/gradle-wrapper.properties"
  [[ -r "$wrapper_properties" ]] || return 1

  distribution_url=$(awk -F= '/^[[:space:]]*distributionUrl[[:space:]]*=/ { sub(/^[^=]*=/, ""); print; exit }' "$wrapper_properties")
  gradle_version=$(printf '%s\n' "$distribution_url" | sed -nE 's#.*gradle-([0-9][0-9A-Za-z._-]*)-(bin|all)\.zip.*#v\1#p')

  [[ -n "$gradle_version" ]] || return 1
  print "$gradle_version"
}

spaceship::gradle::version() {
  local gradle_exe="$1" gradle_version_output gradle_version

  gradle_version_output=$("$gradle_exe" --version)
  gradle_version=$(echo "$gradle_version_output" | awk '{ if ($1 ~ /^Gradle/) { print "v" $2 } }')

  print "$gradle_version"
}

spaceship_gradle() {
  [[ $SPACESHIP_GRADLE_SHOW == false ]] && return

  local gradle_root_dir

  gradle_root_dir=$(spaceship::gradle::find_root_project "$(pwd -P)")

  # Show Gradle status only for applicable folders.
  [[ -n "$gradle_root_dir" ]] &>/dev/null || return

  local gradle_version

  if [[ -f "$gradle_root_dir/gradlew" ]]; then
    gradle_version=$(spaceship::gradle::wrapper_version "$gradle_root_dir")
    if [[ -z "$gradle_version" && "$SPACESHIP_GRADLE_EXECUTE_WRAPPER" == true ]]; then
      gradle_version=$(spaceship::gradle::version "$gradle_root_dir/gradlew")
    fi
  elif spaceship::exists gradle; then
    gradle_version=$(spaceship::gradle::version gradle)
  else
    return
  fi

  [[ -n "$gradle_version" ]] || return
  [[ "$gradle_version" == "$SPACESHIP_GRADLE_DEFAULT_VERSION" ]] && return

  spaceship::section \
    --color "$SPACESHIP_GRADLE_COLOR" \
    --prefix "$SPACESHIP_GRADLE_PREFIX" \
    --symbol "$SPACESHIP_GRADLE_SYMBOL" \
    --suffix "$SPACESHIP_GRADLE_SUFFIX" \
    "${gradle_version}"
}

# Java section
################
export SPACESHIP_JAVA_SYMBOL=" "

# Let Spaceship's standard Java section detect a configured nested Gradle project.
if (( $+functions[spaceship_java] && ! $+functions[_dotfiles_spaceship_java] )); then
  functions[_dotfiles_spaceship_java]=$functions[spaceship_java]

  spaceship_java() {
    if [[ -n "$SPACESHIP_GRADLE_PROJECT_ROOT" ]] && \
       [[ -f "$SPACESHIP_GRADLE_PROJECT_ROOT/settings.gradle" || \
          -f "$SPACESHIP_GRADLE_PROJECT_ROOT/settings.gradle.kts" ]]; then
      (builtin cd -- "$SPACESHIP_GRADLE_PROJECT_ROOT" && _dotfiles_spaceship_java "$@")
      return
    fi

    _dotfiles_spaceship_java "$@"
  }
fi

# Jujutsu section
##################
export SPACESHIP_JJ_PREFIX="on "
export SPACESHIP_JJ_SUFFIX=" "
export SPACESHIP_JJ_CLEAN_SYMBOL="󰂕 "
export SPACESHIP_JJ_DIRTY_SYMBOL="󰂔 "
export SPACESHIP_JJ_ICON_COLOR="yellow"
export SPACESHIP_JJ_DESC_COLOR="yellow"
export SPACESHIP_JJ_DESC_MAX_LENGTH=32

# Spaceship renders sections in bold by default; reset intensity inside the jj section.
SPACESHIP_JJ_NORMAL_INTENSITY=$'%{\e[22m%}'

# Show only a calm clean/dirty icon and the change description, falling back to
# the current change ID when the description is empty.
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

# Hide Spaceship's Git section in jj/git-colocated repositories.
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

# Section order
###############
# Guards prevent duplicate sections when re-sourcing ~/.zshrc.
if spaceship::defined spaceship_jj && [[ ! " ${SPACESHIP_PROMPT_ORDER[@]} " =~ " jj " ]]; then
  spaceship add --before git jj
fi

if [[ ! " ${SPACESHIP_PROMPT_ORDER[@]} " =~ " gradle " ]]; then
  spaceship add gradle
fi

# Keep project runtime versions on the right side of the prompt.
SPACESHIP_PROMPT_ORDER=(${SPACESHIP_PROMPT_ORDER:#node})
SPACESHIP_PROMPT_ORDER=(${SPACESHIP_PROMPT_ORDER:#golang})
SPACESHIP_PROMPT_ORDER=(${SPACESHIP_PROMPT_ORDER:#java})
SPACESHIP_PROMPT_ORDER=(${SPACESHIP_PROMPT_ORDER:#gradle})

# Guards prevent duplicate sections when re-sourcing ~/.zshrc.
SPACESHIP_RPROMPT_ORDER=(${SPACESHIP_RPROMPT_ORDER:#node})
SPACESHIP_RPROMPT_ORDER=(${SPACESHIP_RPROMPT_ORDER:#golang})
SPACESHIP_RPROMPT_ORDER=(${SPACESHIP_RPROMPT_ORDER:#java})
SPACESHIP_RPROMPT_ORDER=(${SPACESHIP_RPROMPT_ORDER:#gradle})
SPACESHIP_RPROMPT_ORDER+=(node golang java gradle)

# Spaceship renders all sections in bold; normalize only the right prompt.
# Re-wrap after Antidote reloads Spaceship, but never wrap our wrapper recursively.
if (( $+functions[spaceship::rprompt] )) && \
   [[ $functions[spaceship::rprompt] != *'_dotfiles_spaceship_rprompt'* ]]; then
  functions[_dotfiles_spaceship_rprompt]=$functions[spaceship::rprompt]

  spaceship::rprompt() {
    local rprompt="$(_dotfiles_spaceship_rprompt "$@")"
    print -rn -- "${rprompt//\%B/%b}"
  }
fi

# Prompt lifecycle
##################
autoload -Uz add-zsh-hook

_dotfiles_precmd() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    export SPACESHIP_PROMPT_PREFIXES_SHOW=true
    print -Pn "\e]0;%n@%m:%2~\a"
  else
    print -Pn "\e]0;%2~\a"
  fi
}

add-zsh-hook -d precmd _dotfiles_precmd 2>/dev/null
add-zsh-hook precmd _dotfiles_precmd

# Runtime toggles
#################
alias show-kube-context='SPACESHIP_KUBECTL_SHOW=true'
alias hide-kube-context='SPACESHIP_KUBECTL_SHOW=false'
