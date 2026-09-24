export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Warp-style prompt editing (must precede zsh-syntax-highlighting)
source $HOME/Developer/dotfiles/zsh/warp-keys.zsh

# zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# warp-keys rebinds right/cmd+right/opt+right to custom widgets; keep them accepting suggestions
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(warp-move-forward-char warp-move-end-of-line)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(warp-move-emacs-forward-word)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zoxide
eval "$(zoxide init zsh)"

# starship prompt (keep last)
eval "$(starship init zsh)"
