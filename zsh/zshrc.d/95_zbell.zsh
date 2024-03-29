#!/usr/bin/env zsh
# zbell (terminal bell after long command)
zmodload zsh/datetime || return
autoload -Uz add-zsh-hook || return
zbell_duration=15
zbell_ignore=($EDITOR vi vim nvim $PAGER tmux firefox chrome chromium \
    man less weechat mpv ncmpcpp alsamixer top htop ghci java)
zbell_timestamp=$EPOCHSECONDS

# right before we begin to execute something, store the time it started at
zbell_begin() {
  zbell_timestamp=$EPOCHSECONDS
  zbell_lastcmd=$1
}
# when it finishes, if it's been running longer than $zbell_duration,
# and we dont have an ignored command in the line, then print a bell.
zbell_end() {
  [[ -z ${zbell_timestamp} ]] && return 0
  ran_long=$(( $EPOCHSECONDS - $zbell_timestamp >= $zbell_duration ))

  has_ignored_cmd=0
  for cmd in ${(s:;:)zbell_lastcmd//|/;}; do
    words=(${(z)cmd})
    util=${words[1]}
    if (( ${zbell_ignore[(i)$util]} <= ${#zbell_ignore} )); then
      has_ignored_cmd=1
      break
    fi
  done

  if (( ! $has_ignored_cmd )) && (( ran_long )); then
    # https://iterm2.com/documentation-escape-codes.html
    print -n "\x1b]9;$zbell_lastcmd\x7"
    print -n "\a"
  fi
  unset zbell_timestamp zbell_lastcmd ran_long has_ignored_cmd cmd words util
}

add-zsh-hook preexec zbell_begin
add-zsh-hook precmd zbell_end
