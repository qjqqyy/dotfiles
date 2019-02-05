#!/usr/bin/env zsh
# pastes & uploads
clipboard() {
  if [[ ! -z $DISPLAY ]]; then
    if (( $+commands[pbcopy] )); then
      clip=pbcopy
    elif (( $+commands[xclip] )); then
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
hastebin() {
  cat $* \
      | curl -sSf --data-binary '@-' https://hastebin.com/documents \
      | sed 's_^{"key":"_https://hastebin.com/_;s/"}$//' \
      | clipboard
}
0x0() {
  curl -sSf -F"file=@$1" https://0x0.st | clipboard
}
autoload -Uz ghetty && alias ghetty='noglob ghetty'
