#!/bin/bash
# macOS system preferences via defaults

# Dock: auto-hide and show
defaults write com.apple.dock autohide -bool true

# Dock: no delay before auto-hide
defaults write com.apple.dock autohide-delay -float 0

# Dock: faster hide/show animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Hot corners
# Values: 0=none, 2=Mission Control, 3=App Windows, 4=Desktop,
#         5=Start Screen Saver, 6=Disable Screen Saver, 7=Dashboard,
#         10=Put Display to Sleep, 11=Launchpad, 12=Notification Center
# Bottom-left: Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
# Top-right: Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0

# Restart Dock to apply changes
killall Dock

echo "Done. macOS defaults applied."
