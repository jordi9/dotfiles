dotfiles
========

A combination of Antibody, Homesick, custom plugins and some private repos.

Some inspiration: [technicalpickles/homesick](http://www.github.com/technicalpickles/homesick), [mathiasbynens/dotfiles](http://www.github.com/mathiasbynens/dotfiles), [getantidote/zdotdir](https://github.com/getantidote/zdotdir)

# Installation 

## Homebrew

Installing Homebrew first we will get Command Line Tools and other basic goodies

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Basic apps to not die in the intent

    brew install iterm2
    brew install bitwarden
    brew install antibody
    
## Homeshick

Install Homeshick first (thanks Homesick!)

    brew install homeshick
    export HOMESHICK_DIR=/opt/homebrew/opt/homeshick
    source "/opt/homebrew/opt/homeshick/homeshick.sh"

Time to set up my ssh config

    homeshick clone https://jordi9@...

Fix file permissions

    sudo chmod 600 ~/.ssh/id_*

Add keys to ssh-agent
    
    eval "$(ssh-agent -s)"
    ssh-add --apple-use-keychain foo_key

Now it's time to clone this `dotfiles` as a Castle

    homeshick clone git@github.com:jordi9/dotfiles.git

This `dotfiles` at the same time is an antidote plugin.

## Optional plugins per laptop

If you want to load more antibody plugins, but depend on the laptop (eg: work), create a file `~/.antibody-boost` to load more bundles.

    $ vim ~/.antibody-boost
    eval $(antidote bundle $HOMESHICK_REPOS/my-secret-home)

## More Homes

Time to setup more homes. For example, private scripts or configs with licenses

    homesick clone git@github.com:jordi9/private-dotfiles-example.git
    homesick link private-dotfiles-example

# One time scripts

All of them located in `init` folder:

    init/brew.sh
    init/cash.sk
    init/macos.zsh
    init/sdkman.zsh

# Setup 

* iTerm2: Load preferences from `conf` folder


## Manytricks settings

If they're not picked up, run:

    killall cfprefsd

Some Moom hotkeys inspired by [Rectangle](https://github.com/rxhanson/Rectangle)](https://github.com/rxhanson/Rectangle)

# Inspiration

* https://github.com/maximbaz/dotfiles
* https://github.com/paulirish/dotfiles
* https://github.com/sharat87/lawn/blob/master/shell/zsh
