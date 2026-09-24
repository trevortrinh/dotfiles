# Warp-style selection at the zsh prompt: shift+arrows select, typing /
# backspace / paste replace the selection, cmd+a/c/x select all, copy, cut.
# Plain cmd/opt+arrow movement is Ghostty's default; it's rebound here only so
# it clears the selection. The key sequences come from ghostty/config.
# Source this BEFORE zsh-syntax-highlighting so its widget wrapping picks these up.

for w in backward-char forward-char emacs-backward-word emacs-forward-word \
         beginning-of-line end-of-line; do
  eval "_warp-select-$w() { ((REGION_ACTIVE)) || zle set-mark-command; zle .$w }"
  eval "_warp-move-$w() { REGION_ACTIVE=0; zle .$w }"
  zle -N _warp-select-$w
  zle -N _warp-move-$w
done

_warp-self-insert()     { ((REGION_ACTIVE)) && zle kill-region; zle .self-insert }
_warp-bracketed-paste() { ((REGION_ACTIVE)) && zle kill-region; zle .bracketed-paste }
_warp-backspace()       { if ((REGION_ACTIVE)); then zle kill-region; else zle .backward-delete-char; fi }
_warp-select-all()      { CURSOR=0; zle set-mark-command; CURSOR=$#BUFFER }
_warp-copy()            { ((REGION_ACTIVE)) || return 0; zle copy-region-as-kill; print -rn -- $CUTBUFFER | pbcopy }
_warp-cut()             { ((REGION_ACTIVE)) || return 0; zle kill-region; print -rn -- $CUTBUFFER | pbcopy }
zle -N self-insert _warp-self-insert
zle -N bracketed-paste _warp-bracketed-paste
for w in backspace select-all copy cut; do zle -N _warp-$w; done

bindkey '\e[1;2D'  _warp-select-backward-char        # shift+left
bindkey '\e[1;2C'  _warp-select-forward-char         # shift+right
bindkey '\e[1;4D'  _warp-select-emacs-backward-word  # opt+shift+left
bindkey '\e[1;4C'  _warp-select-emacs-forward-word   # opt+shift+right
bindkey '\e[1;10D' _warp-select-beginning-of-line    # cmd+shift+left
bindkey '\e[1;10C' _warp-select-end-of-line          # cmd+shift+right

bindkey '\e[D' _warp-move-backward-char              # left
bindkey '\e[C' _warp-move-forward-char               # right
bindkey '\eb'  _warp-move-emacs-backward-word        # opt+left
bindkey '\ef'  _warp-move-emacs-forward-word         # opt+right
bindkey '^A'   _warp-move-beginning-of-line          # cmd+left
bindkey '^E'   _warp-move-end-of-line                # cmd+right

bindkey '^?'        _warp-backspace
bindkey '\e[97;9u'  _warp-select-all                 # cmd+a
bindkey '\e[99;9u'  _warp-copy                       # cmd+c (chained after Ghostty's copy)
bindkey '\e[120;9u' _warp-cut                        # cmd+x
