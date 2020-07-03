#!/usr/bin/env zsh

__prompt_pwd() {
  local PROMPT_PWD_CUTOFF=3
  local IFS=/
  local path=($(print -P '%~'))

  local p
  local s
  for p in ${=path}; do
    printf '%s' "$s${p[1,$PROMPT_PWD_CUTOFF]}"
    s=/
  done

  printf '%s\n' ${p:$PROMPT_PWD_CUTOFF}
}

prompt () {
  case $1 in
    min)
      unsetopt prompt_subst
      PROMPT='%# '
      RPROMPT=
      ;;
    min2)
      unsetopt prompt_subst
      PROMPT='%~ %# '
      RPROMPT=
      ;;
    ssh)
      setopt prompt_subst
      PROMPT='%F{11}┌─%B(%b%F{green}%n%F{11}@%F{12}%m%F{11}%B)─(%b%F{12}%l%B%F{11})─(%b%F{7}%D{%H}%F{12}:%F{7}%D{%M}%F{12}:%F{7}%D{%S}%F{11}%B)─%(?..%F{yellow}[%b%F{red}%?%F{yellow}%B]%F{11}─)(%b%F{blue}$(__prompt_pwd)%B%F{11})%b%F{11}┌─
└─%(#.%F{red}%B#%b.%F{12}%%)%f '
      RPROMPT=
      ;;
    *)
      # normal & tmux prompt
      setopt prompt_subst
      PROMPT='%F{3}$(__prompt_pwd) %F{12}%# %f'
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
