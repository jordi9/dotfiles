# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with **Homeshick** (a bash implementation of Homesick) and **Antidote** (zsh plugin manager). It configures macOS development environments with zsh, git, vim, and various development tools.

## Key Architecture Components

### Zsh and Plugin Architecture

Homeshick owns the personal zsh configuration linked from `home/.zsh/`.
Antidote owns external plugins: public plugins are declared in
`home/.zsh_plugins.txt`, while optional private plugins are declared in
`~/.zsh_plugins.local.txt`. This repository is not loaded as an Antidote plugin.

**Loading Order (`home/.zshrc`):**
1. `~/.zsh/antidote.zsh` initializes Antidote and loads only public plugins from `~/.zsh_plugins.txt`.
2. Personal concern modules load in dependency-safe order: `core.zsh`, `jj.zsh`, `navigation.zsh`, `git.zsh`, and `commands.zsh`.
3. `~/.zsh/private-plugins.zsh` loads optional private Antidote plugins and then the legacy `~/.antidote-boost`. Private definitions therefore retain precedence over personal definitions.
4. `environment.zsh` configures PATH, terminal/SSH behavior, and SDK runtimes.
5. `completion.zsh`, `autosuggestions.zsh`, and `keybindings.zsh` load before `integrations.zsh` initializes Carapace, Atuin, direnv, and zoxide; `prompt.zsh` loads last.

**Plugin Loading:**
- `home/.zsh/antidote.zsh` uses high-performance static loading for public plugins, regenerating `~/.zsh_plugins.zsh` only when `~/.zsh_plugins.txt` is newer.
- `home/.zsh/private-plugins.zsh` independently generates `~/.zsh_plugins.local.zsh` when `~/.zsh_plugins.local.txt` exists and is newer, then sources it after personal config.
- A stale local generated file is not sourced when the local manifest is absent.
- Generated `~/.zsh_plugins.zsh` and `~/.zsh_plugins.local.zsh` files are runtime artifacts; do not edit them as tracked source files.

### Homeshick Integration

Files are organized in the `home/` directory and symlinked to `~` via Homeshick. This includes every personal `home/.zsh/*.zsh` module. The `.homesick_subdir` file indicates this is a Homeshick castle with subdirectory support.

### Configuration Files Location

- **Dotfiles**: `home/.*` (e.g., `.zshrc`, `.gitconfig`, `.vimrc`)
- **XDG Config**: `home/.config/` (e.g., `bat/`, `karabiner/`)
- **ZSH Config**: `home/.zsh/` (modular zsh configuration)
- **iTerm2 Config**: `conf/com.googlecode.iterm2.plist`
- **Init Scripts**: `init/` (one-time setup scripts)
- **Themes**: `themes/` (legacy zsh themes, not actively used)

## Common Commands

### Dotfiles Management

```bash
# Navigate to or reload the dotfiles configuration
dot      # cd ~/.homesick/repos/dotfiles
reload   # alias for source ~/.zshrc

# Link dotfiles after changes
homeshick link dotfiles

# Update dotfiles from remote
homeshick pull dotfiles

# Check status of all castles
homeshick status
```

### Development Workflow

```bash
# Gradle (auto-detects gradlew or uses system gradle)
ge <task>           # Uses gradlew-quiet > gradlew > gradle
gen <task>          # Direct gradle alias

# Git shortcuts (from home/.zsh/git.zsh and .gitconfig)
g st                # git status
g ci                # git commit
g lg                # pretty log graph
gf                  # git fetch
gl                  # git pull with stats
gri                 # rebase interactive on main branch
gpub                # push and set upstream
g-delete-merged-branches  # cleanup merged branches

# Docker
dc                  # docker-compose
d-stop-all          # stop all containers
d-nuke              # full cleanup with volumes

# Kubernetes
k                   # kubectl
show-kube-context   # enable kubectl in prompt
hide-kube-context   # disable kubectl in prompt
```

### Git Configuration

The repository uses conditional git config includes:
- Personal account (default): `jordi@donky.org`
- Personal projects: `~/homespace/` → `.gitconfig-personal`
- Work projects: `~/workspace/` → `.gitconfig-work`

When working in different directories, the appropriate git identity is automatically selected.

## Modifying This Repository

### Adding New Aliases or Functions

Add personal definitions to the Homeshick-owned concern module under `home/.zsh/`:

- `core.zsh` - Locale, config/reload helpers, completion refresh, native history
- `jj.zsh` - jj workspace/open/wrapper logic
- `navigation.zsh` - Directory aliases, ZLE function implementations, Magic Enter command
- `git.zsh` - Git aliases and functions
- `commands.zsh` - General shortcuts plus Aerospace, Gradle, IDE, macOS/Linux/media/Yazi commands
- `environment.zsh` - PATH, terminal/SSH behavior, SDKMAN, Bun, and pnpm
- `integrations.zsh` - Carapace, Atuin, direnv, and zoxide shell hooks
- `keybindings.zsh` - ZLE widget registration and key bindings

Keep definitions in the narrowest existing concern instead of adding a new
Antidote plugin entry for this repository. After editing, run `reload` to apply
changes. If a new module file is added, run `homeshick link dotfiles` before it
can be sourced from `~/.zshrc`.

### Adding New Antidote Plugins

Edit `home/.zsh_plugins.txt` following the format:
```
user/repo
user/repo path:subdirectory
user/repo kind:defer
```

The `.zsh_plugins.zsh` file will auto-regenerate on next shell start.

### Modifying Prompt

Edit `home/.zsh/prompt.zsh` to configure Spaceship prompt segments. Current configuration:
- Time shown, battery/docker/package hidden
- Custom Gradle segment defined directly in `home/.zsh/prompt.zsh`
- Kubernetes context toggleable via `show-kube-context` / `hide-kube-context`

### iTerm2 Preferences

iTerm2 loads preferences from `conf/com.googlecode.iterm2.plist`. After modifying, commit the file (iTerm2 will auto-save changes to this location).

## One-Time Setup Scripts

Located in `init/`, these are run once during initial machine setup:

- `init/brew.sh` - Install Homebrew formulae (ack, bat, git, jq, kubectl, etc.)
- `init/cask.sh` - Install Homebrew casks (GUI applications)
- `init/npm.sh` - Install global npm packages (Claude Code, claude-powerline)
- `init/macos.zsh` - macOS system preferences configuration
- `init/sdkman.zsh` - Install SDKMAN for Java version management

These scripts are not idempotent and should be reviewed before running.

## Special Patterns

### Private Configuration Support

The dotfiles support loading private/company-specific configuration via:
- `~/.zsh_plugins.local.txt` - Additional external Antidote plugins, generated and loaded independently after personal modules
- Private Homeshick castles - Clone additional repos and link them

To add private plugins, create `~/.zsh_plugins.local.txt` with entries in the same format as `.zsh_plugins.txt`:
```
$HOMESHICK_REPOS/company-zsh-tools
git@github.com:company/zsh-tools
```

For a cleaner setup, have a private Homeshick castle provide `home/.zsh_plugins.local.txt` which gets symlinked to `~`.

### Gradle Project Helper

The `gradle-or-gradlew-quiet` function searches parent directories for:
1. `gradlew-quiet` (custom wrapper, preferred)
2. `gradlew` (standard wrapper)
3. Falls back to system `gradle`

This allows consistent `ge` alias across all Gradle projects.

### Git Local Ignore Setup

Use `git-setup-local-ignore` function to create project-specific `.local_gitignore` files that won't be committed. The function copies the excludesfile config to clipboard for pasting into `.git/config`.
