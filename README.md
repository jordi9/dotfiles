# dotfiles

Personal macOS configuration managed with
[Homeshick](https://github.com/andsens/homeshick). Homeshick links files from
`home/` into `~`. [Antidote](https://getantidote.github.io/) installs external
Zsh plugins.

## Install

### Bootstrap Homebrew and GitHub access

Install Homebrew and add it to the current shell:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Install the tools needed to clone this repository. Ghostty and Bitwarden are
installed early for convenience. The Brewfile installs them again harmlessly.

```sh
brew install gh homeshick
brew install --cask ghostty bitwarden
gh auth login  # choose SSH to create and upload this Mac's key
```

Load Homeshick, clone the repository, and link it into `~`:

```sh
export HOMESHICK_DIR=/opt/homebrew/opt/homeshick
source "$HOMESHICK_DIR/homeshick.sh"
homeshick clone git@github.com:jordi9/dotfiles.git
cd ~/.homesick/repos/dotfiles
homeshick link dotfiles
```

### Install packages and runtimes

The Brewfile lists all Homebrew formulae, applications, and fonts. Mise installs
the fallback runtime versions from `~/.config/mise/config.toml`. A project can
override them with its own `mise.toml`.

```sh
./init/brew.sh
./init/mise.sh
```

Clone the source packages used by the pnpm globals and Pi settings:

```sh
mkdir -p ~/dev
jj git clone git@github.com:jordi9/chloe.git ~/dev/chloe
jj git clone git@github.com:jordi9/pi-dac.git ~/dev/pi-dac
jj git clone git@github.com:jordi9/pi-impeccable.git ~/dev/pi-impeccable
```

Finish the setup:

```sh
./init/pnpm.sh
./init/zellij.sh
ya pkg install
./init/doctor.sh
exec zsh
```

`init/pnpm.sh` builds the local packages before linking their commands.
`init/zellij.sh` verifies the pinned zjstatus download before replacing the
plugin. `init/doctor.sh` reads the resulting setup and returns nonzero only for
missing requirements.

### Clean up an existing Mac

After mise and the doctor pass, inspect runtime managers replaced by mise:

```sh
./init/cleanup-legacy.sh
```

Apply the cleanup with:

```sh
./init/cleanup-legacy.sh --apply
./init/doctor.sh
exec zsh
```

The script removes SDKMAN, standalone Bun, and Go values persisted by the old
setup. It leaves npm, pnpm, and Gradle caches alone.

### Restore local configuration

Restore private castles, application preferences, and licenses from the private
runbook. MonoLisa requires a separate license and is not in the Brewfile. Its
absence produces a doctor warning.

Inspect the macOS preferences without changing them:

```sh
./init/macos.zsh
```

Apply the reviewed values with:

```sh
./init/macos.zsh --apply --wipe-dock
```

That command backs up the Dock preferences before erasing pinned applications.
Grant Accessibility, Screen Recording, and login-item permissions in System
Settings.

## Zsh layout

`home/.zshrc` loads configuration in this order:

1. Atuin's PTY proxy.
2. Public Antidote plugins from `~/.zsh_plugins.txt`.
3. Personal modules: `core.zsh`, `jj.zsh`, `navigation.zsh`, `git.zsh`, and
   `commands.zsh`.
4. Optional private plugins through `private-plugins.zsh`.
5. Environment, completion, autosuggestions, keybindings, and integrations.
6. The prompt.

Put personal shell changes in the module that owns the concern:

- `core.zsh`: locale, reload helpers, completion refresh, and native history
- `jj.zsh`: jj workspace and wrapper behavior
- `navigation.zsh`: directory helpers and ZLE navigation widgets
- `git.zsh`: Git aliases and functions
- `commands.zsh`: general command shortcuts
- `environment.zsh`: PATH, terminal behavior, mise shims, and pnpm globals
- `integrations.zsh`: mise, Carapace, Atuin, direnv, and zoxide hooks
- `keybindings.zsh`: widget registration and key bindings

Add public plugins to `home/.zsh_plugins.txt`. Antidote regenerates
`~/.zsh_plugins.zsh` when the manifest changes. The generated file is not
tracked.

For machine-specific plugins, create `~/.zsh_plugins.local.txt`. Each line can
name a local checkout or remote repository:

```text
$HOMESHICK_REPOS/my-private-dotfiles
git@github.com:company/zsh-tools
```

`private-plugins.zsh` generates `~/.zsh_plugins.local.zsh` and loads it after the
personal modules, so private definitions win. When the manifest is absent, the
loader ignores any stale generated file.

Private configuration and licenses belong in separate castles. Keep their names
and setup instructions in the private runbook:

```sh
homeshick clone <private-castle-url>
homeshick link <castle-name>
```

## Daily use

```sh
dot       # cd ~/.homesick/repos/dotfiles
reload    # source ~/.zshrc
```

Run `homeshick link dotfiles` after adding a tracked file. Use `reload` for shell
module changes. Restart the shell after changing an Antidote manifest.

If imported Moom or Manytricks settings do not appear, run `killall cfprefsd`.
Some hotkeys follow [Rectangle](https://github.com/rxhanson/Rectangle).

This setup borrows ideas from
[mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles),
[getantidote/zdotdir](https://github.com/getantidote/zdotdir),
[maximbaz/dotfiles](https://github.com/maximbaz/dotfiles), and
[paulirish/dotfiles](https://github.com/paulirish/dotfiles).
