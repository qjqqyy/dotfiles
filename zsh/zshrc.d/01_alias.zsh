# Aliases
typeset -A _ls_flags _rm_flags _mv_flags _cp_flags
_ls_flags[gnu]='-FH --group-directories-first --color=auto'
_rm_flags[gnu]='-Iv --one-file-system'
_ls_flags[freebsd]='-FHG'
_rm_flags[freebsd]='-iv'
_ls_flags[darwin]='-FHG'
_rm_flags[darwin]='-iv'
_ls_flags[compat]='-FH'
_rm_flags[compat]='-i'
_mv_flags[modern]='-iv'
_cp_flags[modern]='-ipv'
_mv_flags[compat]='-i'
_cp_flags[compat]='-ip'

case $OSTYPE in
  *gnu|*linux*)
    alias ls="ls ${_ls_flags[gnu]}"
    alias cp="cp ${_cp_flags[modern]}"
    alias rm="nocorrect noglob rm ${_rm_flags[gnu]}"
    alias mv="nocorrect noglob mv ${_mv_flags[modern]}"
    ;;
  *darwin*)
    alias ls="ls ${_ls_flags[darwin]}"
    alias cp="cp ${_cp_flags[modern]}"
    alias rm="nocorrect noglob rm ${_rm_flags[darwin]}"
    alias mv="nocorrect noglob mv ${_mv_flags[modern]}"
    ;;
  freebsd*)
    alias ls="ls ${_ls_flags[freebsd]}"
    alias cp="cp ${_cp_flags[modern]}"
    alias rm="nocorrect noglob rm ${_rm_flags[freebsd]}"
    alias mv="nocorrect noglob mv ${_mv_flags[modern]}"
    ;;
  solaris*|openbsd*)
    if hash gls &>/dev/null && hash gcp &>/dev/null && hash gmv &>/dev/null && hash grm &>/dev/null; then
      alias ls="gls ${_ls_flags[gnu]}"
      alias cp="gcp ${_cp_flags[modern]}"
      alias rm="nocorrect noglob grm ${_rm_flags[gnu]}"
      alias mv="nocorrect noglob gmv ${_mv_flags[modern]}"
    else
      alias ls="ls ${_ls_flags[compat]}"
      alias cp="cp ${_cp_flags[compat]}"
      alias rm="nocorrect noglob rm ${_rm_flags[compat]}"
      alias mv="nocorrect noglob mv ${_mv_flags[compat]}"
    fi
    ;;
esac
alias ll='ls -l'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'
alias lah='lla -h'
alias :q='exit'
alias /quit='exit'
if [[ $OSTYPE =~ (openbsd|solaris) ]]; then
  if hash ggrep &>/dev/null; then
    alias grep='ggrep -i --color=auto -d skip'
  else
    alias grep='grep -i'
  fi
else
  alias grep='grep -i --color=auto -d skip'
fi
alias df='df -h'
[[ $OSTYPE =~ linux ]] && alias free='free -m'
alias git='nocorrect noglob git'
# force mouse off
alias mousereset=" printf '\033[?1002l'"

unset _ls_flags _rm_flags _mv_flags _cp_flags
