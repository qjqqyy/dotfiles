#!/usr/bin/env zsh
# pastes & uploads
clipboard() {
  if [[ ! -z $DISPLAY ]]; then
    if hash pbcopy > /dev/null 2>&1; then
      clip=pbcopy
    elif hash xclip > /dev/null 2>&1; then
      clip=xclip
    elif hash xsel > /dev/null 2>&1; then
      clip=xsel
    else
      clip=cat
    fi
  else
    clip=cat
  fi
  $clip
}
sprunge() {
  cat $* | curl -sSf -F 'sprunge=<-' http://sprunge.us | clipboard
}
0x0() {
  curl -sSf -F"file=@$1" https://0x0.st | clipboard
}
autoload -Uz ghetty && alias ghetty='noglob ghetty'
