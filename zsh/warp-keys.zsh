# Warp-style selection at the zsh prompt: shift+arrows select, typing /
# backspace / paste replace the selection, cmd+a/c/x select all, copy, cut.
# Plain cmd/opt+arrow movement is Ghostty's default; it's rebound here only so
# it clears the selection. The key sequences come from ghostty/config.
# Source this BEFORE zsh-syntax-highlighting so its widget wrapping picks these up.

for w in backward-char forward-char emacs-backward-word emacs-forward-word \
         beginning-of-line end-of-line; do
  eval "warp-select-$w() { ((REGION_ACTIVE)) || zle set-mark-command; zle .$w }"
  eval "warp-move-$w() { REGION_ACTIVE=0; zle .$w }"
  zle -N warp-select-$w
  zle -N warp-move-$w
done

warp-self-insert()     { ((REGION_ACTIVE)) && zle kill-region; zle .self-insert }
warp-bracketed-paste() { ((REGION_ACTIVE)) && zle kill-region; zle .bracketed-paste }
warp-backspace()       { if ((REGION_ACTIVE)); then zle kill-region; else zle .backward-delete-char; fi }
warp-select-all()      { CURSOR=0; zle set-mark-command; CURSOR=$#BUFFER }
warp-copy()            { ((REGION_ACTIVE)) || return 0; zle copy-region-as-kill; print -rn -- $CUTBUFFER | pbcopy }
warp-cut()             { ((REGION_ACTIVE)) || return 0; zle kill-region; print -rn -- $CUTBUFFER | pbcopy }
zle -N self-insert warp-self-insert
zle -N bracketed-paste warp-bracketed-paste
for w in backspace select-all copy cut; do zle -N warp-$w; done

bindkey '\e[1;2D'  warp-select-backward-char        # shift+left
bindkey '\e[1;2C'  warp-select-forward-char         # shift+right
bindkey '\e[1;4D'  warp-select-emacs-backward-word  # opt+shift+left
bindkey '\e[1;4C'  warp-select-emacs-forward-word   # opt+shift+right
bindkey '\e[1;10D' warp-select-beginning-of-line    # cmd+shift+left
bindkey '\e[1;10C' warp-select-end-of-line          # cmd+shift+right

bindkey '\e[D' warp-move-backward-char              # left
bindkey '\e[C' warp-move-forward-char               # right
bindkey '\eb'  warp-move-emacs-backward-word        # opt+left
bindkey '\ef'  warp-move-emacs-forward-word         # opt+right
bindkey '^A'   warp-move-beginning-of-line          # cmd+left
bindkey '^E'   warp-move-end-of-line                # cmd+right

bindkey '^?'        warp-backspace
bindkey '\e[97;9u'  warp-select-all                 # cmd+a
bindkey '\e[99;9u'  warp-copy                       # cmd+c (chained after Ghostty's copy)
bindkey '\e[120;9u' warp-cut                        # cmd+x
