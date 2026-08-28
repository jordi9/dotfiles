# Agent guide

This repository contains Jordi's macOS dotfiles. Homeshick links files under
`home/` into `~`. Antidote installs third-party Zsh plugins. The repository uses
jj for version control.

`README.md` is the new-machine runbook. Keep its command order and script flags
in sync with bootstrap changes.

## Shell architecture

`home/.zshrc` loads configuration in dependency order:

1. `atuin-proxy.zsh`
2. Public plugins through `antidote.zsh`
3. `core.zsh`, `jj.zsh`, `navigation.zsh`, `git.zsh`, and `commands.zsh`
4. Optional private plugins through `private-plugins.zsh`
5. `environment.zsh`
6. Completion, autosuggestions, keybindings, and integrations
7. `prompt.zsh`

Homeshick owns the personal modules. This repository is not an Antidote plugin.
Put a shell change in the narrowest existing module:

- `core.zsh`: locale, reload helpers, completion refresh, and native history
- `jj.zsh`: jj workspace and wrapper behavior
- `navigation.zsh`: directory helpers and ZLE navigation widgets
- `git.zsh`: Git aliases and functions
- `commands.zsh`: general shortcuts and tool commands
- `environment.zsh`: PATH, terminal behavior, mise shims, and pnpm globals
- `integrations.zsh`: mise, Carapace, Atuin, direnv, and zoxide hooks
- `keybindings.zsh`: widget registration and key bindings
- `prompt.zsh`: Spaceship configuration and custom prompt segments

Run `homeshick link dotfiles` after adding a file under `home/`. Existing linked
files update in place.

## Plugin ownership

Public plugins belong in `home/.zsh_plugins.txt`. Optional private plugins belong
in `~/.zsh_plugins.local.txt`, usually supplied by a private castle.

Antidote generates `~/.zsh_plugins.zsh` and `~/.zsh_plugins.local.zsh`. Treat both
as runtime output. `private-plugins.zsh` ignores stale local output when the
private manifest is absent and loads private definitions after personal modules.

## Bootstrap contracts

- `Brewfile` is the Homebrew package list.
- `init/brew.sh` runs `brew bundle install --no-upgrade`.
- `home/.config/mise/config.toml` owns global runtime versions and Go paths.
- `init/mise.sh` creates Go directories and installs configured runtimes.
- `init/pnpm.sh` installs standalone JavaScript commands. Pi manages packages and
  extensions declared in `home/.pi/agent/settings.json`.
- `init/zellij.sh` installs the checksum-pinned zjstatus binary. Its `--check`
  mode is read-only and is used by the doctor.
- `init/doctor.sh` is read-only. It reports `OK`, `WARN`, and `FAIL`, and returns
  nonzero only when requirements are missing.
- `init/macos.zsh` is read-only by default. Writes require `--apply`; erasing
  Dock applications also requires `--wipe-dock` and creates a backup first.

Package installers and `init/macos.zsh --apply` change the machine. Run them only
when the user asks. Never add private castle names, private repository URLs, or
secret-file inventories to public setup scripts or documentation.

## Verification

Use the checks that match the change:

```sh
# POSIX setup scripts
sh -n init/brew.sh init/doctor.sh init/mise.sh init/pnpm.sh init/zellij.sh
shellcheck init/brew.sh init/doctor.sh init/mise.sh init/pnpm.sh init/zellij.sh

# Zsh configuration
for file in home/.zprofile home/.zshrc home/.zsh/*.zsh init/macos.zsh; do
  zsh -n "$file" || exit
done

# Package and machine state
brew bundle check --file Brewfile
./init/doctor.sh
```

The doctor may report expected local warnings for unpublished jj work and manual
macOS permissions. Record failures instead of hiding them.

## Other tracked configuration

- `home/.config/` contains XDG application configuration.
- `home/.gitconfig` selects identities through directory-based includes.
- `themes/` contains legacy Zsh themes.

## Repository helpers

`gradle-or-gradlew-quiet` searches upward for `gradlew-quiet`, then `gradlew`, and
finally uses system Gradle. Keep that order when changing Gradle aliases.

`git-setup-local-ignore` creates a project `.local_gitignore` and copies the
required Git configuration to the clipboard. Keep project-local excludes out of
tracked ignore files.
