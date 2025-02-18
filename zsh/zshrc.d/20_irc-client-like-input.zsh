# from http://zshwiki.org/home/zle/ircclientlikeinput

fake-accept-line() {
  if [[ -n "$BUFFER" ]];
  then
    print -S "$BUFFER"
  fi
  return 0
}
zle -N fake-accept-line

down-or-fake-accept-line() {
  if (( HISTNO == HISTCMD )) && [[ "$RBUFFER" != *$'\n'* ]];
  then
    zle fake-accept-line
  fi
  zle .down-line-or-history "$@"
}
zle -N down-line-or-history down-or-fake-accept-line

