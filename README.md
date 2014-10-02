dotfiles
========

A combination of Antigen, Homesick and Dropbox dotfiles setup. 

Inspiration: technicalpickles/homesick, mathiasbynens/dotfiles

# Instalation 

## Homebrew

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

## Homesick

    gem install homesick

Now it's time to clone the dotfiles as a Castle

    homesick clone jordi9/dotfiles

And linking time

    homesick link dotfiles

Start a new shell and everything should be in place

## Brew

Install cli tools

    ./Brewfile

And Apps

    ./Caskfile

## One time scripts

### Private dotfiles

With Dropbox in place, it's time to setup some links for private stuff

    init/private.zsh

### OS X config

    init/osx.zsh
