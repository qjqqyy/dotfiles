#!/usr/bin/env zsh

prompt () {
  case $1 in
    min)
      PROMPT='%# '
      RPROMPT=
      ;;
    min2)
      PROMPT='%~ %# '
      RPROMPT=
      ;;
    ssh)
      PROMPT='%F{11}┌─%B(%b%F{green}%n%F{11}@%F{12}%m%F{11}%B)─(%b%F{12}%l%B%F{11})─(%b%F{7}%D{%H}%F{12}:%F{7}%D{%M}%F{12}:%F{7}%D{%S}%F{11}%B)─%(?..%F{yellow}[%b%F{red}%?%F{yellow}%B]%F{11}─)(%b%F{blue}%~%B%F{11})%b%F{11}┌─
└─%(#.%F{red}%B#%b.%F{12}%%)%f '
      RPROMPT=
      ;;
    *)
      # normal & tmux prompt
      PROMPT='%F{3}%~ %F{12}%# %f'
      RPROMPT='%(?.%F{red}ヾ(●´▽｀●)ﾉ彡☆勹”ﾉヽ.%F{red}┻━┻%F{magenta} ︵ ╯(°□° ╯%))'
      ;;
  esac
}

[[ $TERM =~ (rxvt|screen|tmux) ]] && ZLE_RPROMPT_INDENT=0

if [[ -n $SSH_CLIENT ]]; then
  prompt ssh
else
  prompt
fi
# fallback prompt
#PROMPT='%n@%m:%~ %# '
