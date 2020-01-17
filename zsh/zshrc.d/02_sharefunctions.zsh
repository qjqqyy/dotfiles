#!/usr/bin/env zsh
# pastes & uploads
clipboard() {
  if (( $+commands[clip.exe] )); then
    clip=clip.exe
  elif (( $+commands[pbcopy] )); then
    clip=pbcopy
  elif [[ ! -z $DISPLAY ]]; then
    if (( $+commands[xclip] )); then
      clip=xclip
    elif (( $+commands[xsel] )); then
      clip=xsel
    else
      clip=cat
    fi
  else
    clip=cat
  fi
  $clip
}
