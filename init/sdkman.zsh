#!/bin/zsh

# From http://sdkman.io/install.html

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 8.0.181-oracle
sdk install gradle
sdk install maven