#!/bin/zsh

# Inspired by ~/.osx — https://mths.be/osx
# More examples https://github.com/ymendel/dotfiles/tree/master/osx
# How to discover defaults: https://pawelgrzybek.com/change-macos-user-preferences-via-command-line/

# Ask for the administrator password upfront
sudo -v

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false


###############################################################################
# High Sierra dark mode for mojave                                            #
###############################################################################

# https://www.tekrevue.com/tip/only-dark-menu-bar-dock-mojave/
# System Preferences > General and select Light for Appearance > Run:
defaults write -g NSRequiresAquaSystemAppearance -bool Yes
# Logout. System Preferences > General and select Dark for Appearance
# Back to normal: defaults delete -g NSRequiresAquaSystemAppearance"

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

###############################################################################
# Dock, Hot corners                                                           #
###############################################################################

# Tiny Dock!
defaults write com.apple.dock tilesize -int 16

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array ""

# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Bottom right screen corner → Mission Control
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# disable "natural" (touchscreen-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# enable ctrl modifier key + scrolling for zoom in/out
defaults write com.apple.AppleMultitouchTrackpad HIDScrollZoomModifierMask -int 262144
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad HIDScrollZoomModifierMask -int 262144

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Keyboard Shortcuts                                                          #
###############################################################################

# Launchpad & Dock / Turn Dock hiding
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 "{ enabled = 0; value = { parameters = (100,2,1572864); type = 'standard';};}"

#  Mission Control / Application windows
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 "{ enabled = 0; value = { parameters = (65535,125,8781824); type = 'standard';};}"

# Mission Control / Move left a space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{ enabled = 1; value = { parameters = (65535,123,11927552); type = 'standard';};}"

# Mission Control / Move right a space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{ enabled = 1; value = { parameters = (65535,124,11796480); type = 'standard';};}"

# Mission Control / Switch to Desktop 1
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "{ enabled = 1; value = { parameters = (49,18,1179648); type = 'standard';};}"

# Mission Control / Switch to Desktop 2
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 "{ enabled = 1; value = { parameters = (50,19,1179648); type = 'standard';};}"

# Input sources / Select next source
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "{ enabled = 1; value = { parameters = (32,49,1572864); type = 'standard';};}"

# Screenshots / Copy picture of selected area to clipboard
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 31 "{ enabled = 1; value = { parameters = (52,21,655360); type = 'standard';};}"

# Spotlight / Show spotlight search
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{ enabled = 1; value = { parameters = (32,49,524288); type = 'standard';};}"

# Accessibility / Turn voiceover on off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 59 "{ enabled = 0; value = { parameters = (65535,96,9437184); type = 'standard';};}"

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Dock" "Finder"; do
  killall "${app}" > /dev/null 2>&1
done

echo "Done. Note that some of these changes require a logout/restart to take effect."