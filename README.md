dotfiles
========

A combination of Antigen, Homesick and some private repos at Bitbucket dotfiles setup. 

Some inspiration: [technicalpickles/homesick](http://www.github.com/technicalpickles/homesick), [mathiasbynens/dotfiles](http://www.github.com/mathiasbynens/dotfiles)

# Installation 

## Homebrew

Installing Homebrew first we will get Command Line Tools (required) and an old git version for free that would do the trick to use homesick

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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

## Brew

Install cli tools

    ./Brewfile

And Apps

    ./Caskfile

## One time scripts

### OS X config

    init/osx.zsh
