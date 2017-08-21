# Aliases
case $OSTYPE in
  *gnu|*linux*)
    alias ls='ls -FH --group-directories-first --color=auto'
    alias rm='nocorrect noglob rm -Iv --one-file-system'
    ;;
  *darwin*)
    alias ls='ls -FGH'
    alias rm='nocorrect noglob rm -iv'
    ;;
  freebsd*)
    alias ls='ls -FGH'
    alias rm='nocorrect noglob rm -Ivx'
    ;;
  solaris*|openbsd*)
    alias ls='ls -FH'
    alias rm='nocorrect noglob rm -i'
    ;;
esac
# # be paranoid
if [[ $OSTYPE =~ (openbsd|solaris) ]]; then
  alias mv='nocorrect noglob mv -i'
else
  alias mv='nocorrect noglob mv -iv'
fi
alias cp='cp -ip'
alias ll='ls -l'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'
alias lah='lla -h'
alias :q='exit'
alias /quit='exit'
if [[ $OSTYPE =~ freebsd ]]; then
  alias grep='bsdgrep -i --color=auto -d skip'
elif [[ $OSTYPE =~ (openbsd|solaris) ]]; then
  alias grep='grep -i'
else
  alias grep='grep -i --color=auto -d skip'
fi
alias df='df -h'
[[ $OSTYPE =~ linux ]] && alias free='free -m'  # show sizes in MB
alias git='nocorrect noglob git'
# force mouse off
alias mousereset=" printf '\033[?1002l'"
