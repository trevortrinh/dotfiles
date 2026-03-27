export PATH="$HOME/.local/bin:$PATH"

# aliases
alias k="kubectl"
alias g="gcloud"
alias qb="kubie"

# zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zoxide
eval "$(zoxide init zsh)"

# starship prompt (keep last)
eval "$(starship init zsh)"
