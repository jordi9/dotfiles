dotfiles
========

Personal dotfiles managed with [Homeshick](https://github.com/andsens/homeshick)
and external zsh plugins managed with [Antidote](https://getantidote.github.io/).
Homeshick links the personal configuration in `home/`, including the modules in
`home/.zsh/`; Antidote loads public and optional private third-party plugins.

Inspiration
from [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles), [getantidote/zdotdir](https://github.com/getantidote/zdotdir), [maximbaz/dotfiles](https://github.com/maximbaz/dotfiles),
and [paulirish/dotfiles](https://github.com/paulirish/dotfiles).

# Installation

## Homebrew

Get Homebrew first (includes Command Line Tools):

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Essentials

    brew install gh
    brew install ghostty
    brew install bitwarden

## Homeshick

    brew install homeshick
    export HOMESHICK_DIR=/opt/homebrew/opt/homeshick
    source "/opt/homebrew/opt/homeshick/homeshick.sh"

Set up SSH (one key per device):

    brew install gh
    gh auth login  # choose SSH, generates key & uploads to GitHub

Then grab these dotfiles:

    homeshick clone git@github.com:jordi9/dotfiles.git

Run `homeshick link dotfiles` after adding files so the new modules are linked
into `~/.zsh/`.

## Zsh architecture

`home/.zshrc` loads the shell configuration in this order:

1. Public Antidote plugins from `~/.zsh_plugins.txt`.
2. Personal modules: `core.zsh`, `jj.zsh`, `navigation.zsh`, `git.zsh`, and
   `commands.zsh`.
3. Optional private Antidote plugins (and the legacy `~/.antidote-boost`) via
   `private-plugins.zsh`, after personal config so private definitions win.
4. `environment.zsh` configures PATH, terminal behavior, and SDK runtimes.
5. Completion, autosuggestions, and keybindings load before `integrations.zsh`
   initializes Carapace, Atuin, direnv, and zoxide; the prompt loads last.

Add personal aliases and functions to the module that owns their concern:

- `core.zsh`: locale, config/reload helpers, completion refresh, native history
- `jj.zsh`: jj workspace/open/wrapper behavior
- `navigation.zsh`: directory aliases, ZLE implementations, Magic Enter command
- `git.zsh`: Git aliases and functions
- `commands.zsh`: general shortcuts plus Aerospace, Gradle, IDE, OS, media, and Yazi commands
- `environment.zsh`: PATH, terminal/SSH behavior, SDKMAN, Bun, and pnpm
- `integrations.zsh`: Carapace, Atuin, direnv, and zoxide shell hooks
- `keybindings.zsh`: ZLE widget registration and key bindings

Homeshick owns these personal modules. Add public external plugins to
`home/.zsh_plugins.txt`; Antidote generates `~/.zsh_plugins.zsh` at shell
startup when the manifest is newer. The generated file is not a source file
and should not be edited manually.

## Private plugins

For machine-specific or work plugins, create `~/.zsh_plugins.local.txt`:

    $HOMESHICK_REPOS/my-private-dotfiles
    git@github.com:company/zsh-tools

`private-plugins.zsh` generates and sources `~/.zsh_plugins.local.zsh`
independently when the local manifest exists. It loads after the personal
modules, allowing private plugin definitions to override them. The generated
file is ignored when the local manifest is absent.

## More Castles

Private configs, license keys, work stuff:

    homeshick clone git@github.com:jordi9/private-dotfiles-example.git
    homeshick link private-dotfiles-example

# One-time setup

Scripts in `init/` for fresh machines:

    init/brew.sh      # CLI tools (bat, git, jq, kubectl, etc.)
    init/cask.sh      # GUI apps
    init/go.sh        # Go paths and caches (avoids ~/go)
    init/macos.zsh    # macOS preferences
    init/sdkman.zsh   # Java version management

Run `init/brew.sh` before `init/go.sh`. Review scripts before running—some
aren't idempotent.

## yazi

Need to install flavours and plugins, in `.config/yazi`:

    ya pkg install

# Post-install

**Moom/Manytricks**: If settings don't load, try `killall cfprefsd`. Some hotkeys based
on [Rectangle](https://github.com/rxhanson/Rectangle).

# Day-to-day

```bash
dot       # jump to the dotfiles repo
reload    # reload zsh config
```

After editing, `reload` picks up personal configuration changes. Restart the
shell after changing an Antidote manifest so its static plugin file is updated.
