#!/bin/bash
# macOS system preferences via defaults

# --- Global ---
# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable inline predictions
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# No feedback sound on volume change
defaults write NSGlobalDomain "com.apple.sound.beep.feedback" -bool false

# --- Dock ---
# Auto-hide
defaults write com.apple.dock autohide -bool true

# No delay before auto-hide
defaults write com.apple.dock autohide-delay -float 0

# Faster hide/show animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Tile size
defaults write com.apple.dock tilesize -int 57

# Don't rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

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

# --- Window Manager ---
# Disable Stage Manager
defaults write com.apple.WindowManager GloballyEnabled -bool false

# Disable click wallpaper to show desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# --- Finder ---
# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Arrange by name
defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"

# --- Screenshot ---
# Save screenshots to ~/Pictures/Screenshots
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"

# Default to selection mode
defaults write com.apple.screencapture style -string "selection"

# Show clicks in screen recordings
defaults write com.apple.screencapture showsClicks -bool true

# --- Trackpad ---
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# --- Restart affected apps ---
killall Dock
killall Finder
killall SystemUIServer 2>/dev/null

echo "Done. macOS defaults applied."
