# Aliases
alias cd=' cd'
if  [[ $OSTYPE =~ gnu ]] 
then
    alias ls=' ls -FH --group-directories-first --color=auto'
    alias mv='nocorrect noglob timeout 5 mv -iv'
    alias rm='nocorrect noglob timeout 5 rm -Iv --one-file-system'
elif [[ $OSTYPE =~ (darwin|bsd) ]]
then
    alias ls=' ls -FGH'
    alias mv='nocorrect noglob mv -iv'
    alias rm='nocorrect noglob rm -iv'
fi
alias ll='ls -l'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'
alias lah='lla -h'
alias :q='exit'
alias cp="cp -i"                          # confirm before overwriting something
alias grep='grep -i --color=tty -d skip'
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias mosh='mosh --predict=experimental'
alias git='nocorrect noglob git'
alias sapt='sudo apt'
alias apt='nocorrect noglob apt'
# force mouse off
alias mousereset="printf '\033[?1002l'"
