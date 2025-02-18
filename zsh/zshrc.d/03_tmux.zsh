if [[ -n "$TMUX" ]]; then
  if [[ "$( tmux list-windows | wc -l )" -eq 1 ]]; then
    tmux set status off
  else
    tmux set status on
  fi

fi
