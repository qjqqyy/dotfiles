#!/usr/bin/env zsh
# pastes & uploads
clipboard() {
  if (( $+commands[clip.exe] )); then
    clip.exe
  elif (( $+commands[pbcopy] )); then
    pbcopy
  elif [[ ! -z $DISPLAY ]]; then
    if (( $+commands[xclip] )); then
      xclip
    elif (( $+commands[xsel] )); then
      xsel
    else
      cat
    fi
  else
    cat
  fi
}
