#!/bin/bash
set -e

DOTFILES="$HOME/Developer/dotfiles"

echo "==> Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

echo "==> Creating symlinks"

# Shell
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"

# Starship
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

# LinearMouse
mkdir -p "$HOME/.config/linearmouse"
ln -sf "$DOTFILES/linearmouse.json" "$HOME/.config/linearmouse/linearmouse.json"

# pgcli
ln -sf "$DOTFILES/pgcli.config" "$HOME/.pgclirc"

# App preferences (import, not symlink — plists don't work as symlinks)
echo "==> Importing app preferences"
defaults import com.lwouis.alt-tab-macos "$DOTFILES/alt-tab.plist"
defaults import com.knollsoft.Rectangle "$DOTFILES/rectangle.plist"

# macOS defaults
echo "==> Applying macOS defaults"
bash "$DOTFILES/macos-defaults.sh"

echo "==> Done!"
