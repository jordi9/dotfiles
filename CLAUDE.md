# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with **Homeshick** (a bash implementation of Homesick) and **Antidote** (zsh plugin manager). It configures macOS development environments with zsh, git, vim, and various development tools.

## Key Architecture Components

### Plugin System Architecture

The dotfiles repository is itself an Antidote plugin loaded via `$HOMESHICK_REPOS/dotfiles` in `.zsh_plugins.txt`. This dual nature (both a Homeshick castle and an Antidote plugin) is the core architectural pattern.

**Loading Order (home/.zshrc):**
1. `~/.zsh/antidote.zsh` - Initializes Antidote and loads plugins from `.zsh_plugins.txt`
2. `~/.zsh/prompt.zsh` - Configures Spaceship prompt with custom segments
3. `~/.zsh/claude.zsh` - Sets up Claude Code CLI path
4. `~/.zsh/sdkman.zsh` - Initializes SDKMAN for Java version management

**Plugin Loading (home/.zsh/antidote.zsh):**
- Uses high-performance static loading: generates `.zsh_plugins.zsh` from `.zsh_plugins.txt`
- Regenerates only when `.zsh_plugins.txt` or `.zsh_plugins.local.txt` is modified (timestamp check)
- Supports optional private plugins via `~/.zsh_plugins.local.txt` (merged with main plugins file)

### Homeshick Integration

Files are organized in `home/` directory and symlinked to `~` via Homeshick. The `.homesick_subdir` file indicates this is a Homeshick castle with subdirectory support.

### Configuration Files Location

- **Dotfiles**: `home/.*` (e.g., `.zshrc`, `.gitconfig`, `.vimrc`)
- **XDG Config**: `home/.config/` (e.g., `bat/`, `karabiner/`)
- **ZSH Config**: `home/.zsh/` (modular zsh configuration)
- **Claude Config**: `home/.claude/` (Claude Code settings and commands)
- **iTerm2 Config**: `conf/com.googlecode.iterm2.plist`
- **Init Scripts**: `init/` (one-time setup scripts)
- **Themes**: `themes/` (legacy zsh themes, not actively used)

## Common Commands

### Dotfiles Management

```bash
# Navigate to dotfiles repository
homecnf  # alias for cd ~/.homesick/repos/dotfiles

# Reload zsh configuration
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

# Git shortcuts (from dotfiles.plugin.zsh and .gitconfig)
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

Edit `dotfiles.plugin.zsh` (the main plugin file loaded by Antidote). This file contains:
- Environment variables and exports
- Aliases for common tools
- Custom functions (gradle helpers, git utilities, etc.)
- Key bindings for zsh-history-substring-search

After editing, run `reload` to apply changes.

### Adding New Antidote Plugins

Edit `home/.zsh_plugins.txt` following the format:
```
user/repo
user/repo path:subdirectory
user/repo kind:defer
```

The `.zsh_plugins.zsh` file will auto-regenerate on next shell start.

### Adding Claude Code Commands

Create markdown files in `home/.claude/commands/` with frontmatter:
```markdown
---
allowed-tools: Bash(git:*)
description: Brief description
---

Command prompt here
```

See `home/.claude/commands/gci.md` for a complete example.

### Modifying Prompt

Edit `home/.zsh/prompt.zsh` to configure Spaceship prompt segments. Current configuration:
- Time shown, battery/docker/package hidden
- Custom Gradle segment from `~/.zsh/spaceship/spaceship-gradle.plugin.zsh`
- Kubernetes context toggleable via `show-kube-context` / `hide-kube-context`

### iTerm2 Preferences

iTerm2 loads preferences from `conf/com.googlecode.iterm2.plist`. After modifying, commit the file (iTerm2 will auto-save changes to this location).

## One-Time Setup Scripts

Located in `init/`, these are run once during initial machine setup:

- `init/brew.sh` - Install Homebrew formulae (ack, bat, git, jq, kubectl, etc.)
- `init/cask.sh` - Install Homebrew casks (GUI applications)
- `init/macos.zsh` - macOS system preferences configuration
- `init/sdkman.zsh` - Install SDKMAN for Java version management

These scripts are not idempotent and should be reviewed before running.

## Special Patterns

### Private Configuration Support

The dotfiles support loading private/company-specific configuration via:
- `~/.zsh_plugins.local.txt` - Additional Antidote plugins (merged with `.zsh_plugins.txt`)
- Private Homeshick castles - Clone additional repos and link them

To add private plugins, create `~/.zsh_plugins.local.txt` with entries in the same format as `.zsh_plugins.txt`:
```
$HOMESHICK_REPOS/dotfiles-private
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
