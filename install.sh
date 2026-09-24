#!/bin/bash
set -e

DOTFILES="$HOME/Developer/dotfiles"

echo "==> Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

echo "==> Creating symlinks"

# Shell
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"

# Scripts
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES/bin/ai-warm" "$HOME/.local/bin/ai-warm"

# launchd agent — warming pings that keep the 5h usage windows cycling.
# launchd won't follow symlinks, so substitute $HOME and copy into place.
echo "==> Installing launchd warming agent"
mkdir -p "$HOME/.local/state" "$HOME/Library/LaunchAgents"
label="com.trevor.ai-warm"
dest="$HOME/Library/LaunchAgents/$label.plist"
domain="gui/$(id -u)"
sed "s|__HOME__|$HOME|g" "$DOTFILES/launchd/$label.plist" > "$dest"
# Use the modern bootstrap/kickstart interface; legacy `load -w` silently fails
# to actually run the job on recent macOS.
launchctl bootout "$domain/$label" 2>/dev/null || true
launchctl bootstrap "$domain" "$dest"
launchctl kickstart "$domain/$label"   # tick once now; StartInterval handles the rest

# Claude Code — both profiles (default + `claude-personal`) share one config
for dir in "$HOME/.claude" "$HOME/.claude-personal"; do
  mkdir -p "$dir"
  ln -sf "$DOTFILES/.claude/settings.json" "$dir/settings.json"
done
ln -sf "$DOTFILES/.claude/statusline.py" "$HOME/.claude/statusline.py"

# Ghostty (also read by cmux)
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# cmux
mkdir -p "$HOME/.config/cmux"
ln -sf "$DOTFILES/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"

# Starship
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

# LinearMouse
mkdir -p "$HOME/.config/linearmouse"
ln -sf "$DOTFILES/linearmouse.json" "$HOME/.config/linearmouse/linearmouse.json"

# pgcli
ln -sf "$DOTFILES/pgcli.config" "$HOME/.pgclirc"

# Cargo (git-fetch-with-cli so libgit2's ssh-agent auth doesn't break private git deps over SSH)
mkdir -p "$HOME/.cargo"
ln -sf "$DOTFILES/cargo-config.toml" "$HOME/.cargo/config.toml"

# App preferences (import, not symlink — plists don't work as symlinks)
echo "==> Importing app preferences"
defaults import com.lwouis.alt-tab-macos "$DOTFILES/alt-tab.plist"
defaults import com.knollsoft.Rectangle "$DOTFILES/rectangle.plist"

# macOS defaults
echo "==> Applying macOS defaults"
bash "$DOTFILES/macos-defaults.sh"

echo "==> Done!"
