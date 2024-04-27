# Aliases
typeset -A _ls_flags _rm_flags _mv_flags _cp_flags
_ls_flags[gnu]='-FH --group-directories-first --color=auto'
_ls_flags[freebsd]='-FHG'
_ls_flags[compat]='-FH'
_rm_flags[gnu]='-Iv --one-file-system'
_rm_flags[freebsd]='-iv'
_rm_flags[compat]='-i'
_mv_flags[modern]='-iv'
_mv_flags[compat]='-i'
_cp_flags[modern]='-ipv'
_cp_flags[compat]='-ip'

case $OSTYPE in
  *gnu|*linux*)
    alias ls="ls ${_ls_flags[gnu]}"
    alias cp="cp ${_cp_flags[modern]}"
    [[ $OSTYPE =~ musl ]] && alias rm="nocorrect noglob rm ${_rm_flags[freebsd]}"\
                          || alias rm="nocorrect noglob rm ${_rm_flags[gnu]}"
    alias mv="nocorrect noglob mv ${_mv_flags[modern]}"
    ;;
  *darwin*|freebsd*)
    alias ls="ls ${_ls_flags[freebsd]}"
    alias cp="cp ${_cp_flags[modern]}"
    alias rm="nocorrect noglob rm ${_rm_flags[freebsd]}"
    alias mv="nocorrect noglob mv ${_mv_flags[modern]}"
    ;;
  solaris*|openbsd*)
    if (( $+commands[gls] )) && (( $+commands[gcp] )) && (( $+commands[gmv] )) && (( $+commands[grm] )); then
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
alias tree='tree -F'
alias :q='exit'
alias /quit='exit'
if [[ $OSTYPE =~ (openbsd|solaris|linux-musl) ]]; then
  if (( $+commands[ggrep] )); then
    alias grep='ggrep -i --color=auto -d skip'
  else
    alias grep='grep -i'
  fi
else
  alias grep='grep -i --color=auto -d skip'
fi
if (( $+commands[rg] )); then
  alias rg='rg -S'
fi
alias df='df -h'
alias git='nocorrect noglob git'
# force mouse off
alias mousereset=" printf '\033[?1002l'"

unset _ls_flags _rm_flags _mv_flags _cp_flags
