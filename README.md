dotfiles
========

Personal dotfiles managed with [Homeshick](https://github.com/andsens/homeshick)
and [Antidote](https://getantidote.github.io/). The fun part: this repo is both a Homeshick castle *and* an Antidote
plugin.

Inspiration
from [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles), [getantidote/zdotdir](https://github.com/getantidote/zdotdir), [maximbaz/dotfiles](https://github.com/maximbaz/dotfiles),
and [paulirish/dotfiles](https://github.com/paulirish/dotfiles).

# Installation

## Homebrew

Get Homebrew first (includes Command Line Tools):

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Essentials

    brew install ghostty
    brew install bitwarden

## Homeshick

    brew install homeshick
    export HOMESHICK_DIR=/opt/homebrew/opt/homeshick
    source "/opt/homebrew/opt/homeshick/homeshick.sh"

Set up SSH first:

    homeshick clone https://jordi9@...
    sudo chmod 600 ~/.ssh/id_*
    eval "$(ssh-agent -s)"
    ssh-add --apple-use-keychain your_key

Then grab these dotfiles:

    homeshick clone git@github.com:jordi9/dotfiles.git

The dotfiles repo is also loaded as an Antidote plugin via `.zsh_plugins.txt`.

## Private plugins

For machine-specific or work plugins, create `~/.zsh_plugins.local.txt`:

    $HOMESHICK_REPOS/my-private-dotfiles
    git@github.com:company/zsh-tools

This gets merged with the main plugins file automatically.

## More Castles

Private configs, license keys, work stuff:

    homeshick clone git@github.com:jordi9/private-dotfiles-example.git
    homeshick link private-dotfiles-example

# One-time setup

Scripts in `init/` for fresh machines:

    init/brew.sh      # CLI tools (bat, git, jq, kubectl, etc.)
    init/cask.sh      # GUI apps
    init/macos.zsh    # macOS preferences
    init/sdkman.zsh   # Java version management

Review before running—these aren't idempotent.

# Post-install

**Moom/Manytricks**: If settings don't load, try `killall cfprefsd`. Some hotkeys based
on [Rectangle](https://github.com/rxhanson/Rectangle).

# Day-to-day

```bash
homecnf   # jump to dotfiles repo
reload    # reload zsh config
```

After editing, `reload` picks up changes. For new Antidote plugins, just restart your shell.
