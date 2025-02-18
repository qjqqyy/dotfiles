if (( $+commands[fzf] )); then
  [[ -n "$TMUX" ]] && export FZF_TMUX=1

  # I don't actually like fuzzy finding
  export FZF_DEFAULT_OPTS="--exact --layout=reverse-list --color=16,bg+:0,fg+:15,gutter:10,prompt:2,border:11,pointer:5"
  export FZF_DEFAULT_COMMAND='fd --hidden --follow'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

  eval "$( fzf --zsh )"
fi
