dotfiles
========

A combination of Antigen, Homesick and some private repos at Bitbucket dotfiles setup. 

Some inspiration: [technicalpickles/homesick](http://www.github.com/technicalpickles/homesick), [mathiasbynens/dotfiles](http://www.github.com/mathiasbynens/dotfiles)

# Installation 

## Homebrew

Installing Homebrew first we will get Command Line Tools (required) and an old git version for free that would do the trick to use homesick

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

## Ruby

Due to newer ruby versions in macOS, gem needs sudo (wrong) to run. Better install ruby ourselves:

    brew install rbenv
    init/ruby.zsh

## Homesick

Install Homesick first

    gem install homesick

Time to set up my ssh keys

    homesick clone https://jordi9@bitbucket.org/jordi9/ssh-home.git
    homesick link ssh-home

Fix file permissions

    sudo chmod 600 ~/.ssh/id_rsa
    sudo chmod 600 ~/.ssh/id_rsa.pub

Now it's time to clone this dotfiles as a Castle

    homesick clone git@github.com:jordi9/dotfiles.git
    homesick link dotfiles

And private scripts and settings

    homesick clone git@bitbucket.org:jordi9/private-home.git
    homesick link private-home

Time to change the shell to zsh

    chsh -s /bin/zsh

## Upgrade zsh

Follow steps at https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/

# One time scripts

All of them located in `init` folder:

    init/brew.sh
    init/cash.sk
    init/macos.zsh
    init/sdkman.zsh

## Manytricks settings

If they're not picked up, run:

    killall cfprefsd

Some Moom hotkeys inspired in [Rectangle](https://github.com/rxhanson/Rectangle)

# Inspiration

* https://github.com/maximbaz/dotfiles
* https://github.com/paulirish/dotfiles
* https://github.com/sharat87/lawn/blob/master/shell/zsh
