if (( $+commands[fzf] )); then
  [[ -n "$TMUX" ]] && export FZF_TMUX=1
  
  export FZF_DEFAULT_OPTS="--exact --layout=reverse-list --color=16,bg+:0,fg+:15,gutter:10,prompt:2,border:11,pointer:5"

  local fdfind
  if (( $+commands[fd] )); then
    fdfind="fd"
  elif (( $+commands[fdfind] )); then
    fdfind="fdfind"
  fi

  if [[ -n "$fdfind" ]]; then
    export FZF_DEFAULT_COMMAND="$fdfind --hidden --follow"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
  fi
  ( fzf --zsh 2>/dev/null || cat /usr/share/doc/fzf/examples/key-bindings.zsh /usr/share/doc/fzf/examples/completion.zsh ) | source /dev/fd/0
fi
