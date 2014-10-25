autoload -Uz compinit
compinit
setopt completealiases
#zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*:descriptions' format '%U%B%d%b%u' 
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' menu select=6
zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
