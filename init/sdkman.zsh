#!/bin/zsh

# From http://sdkman.io/install.html

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 11.0.7.hs-adpt
sdk install gradle
sdk install groovy