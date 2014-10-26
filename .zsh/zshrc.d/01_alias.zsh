# Aliases
alias cd=' cd'
alias ls=' ls -F --group-directories-first --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'
alias lah='lla -h'
alias mv='nocorrect noglob timeout 5 mv -iv'
alias rm='nocorrect noglob timeout 5 rm -Iv --one-file-system'
alias cp="cp -i"                          # confirm before overwriting something
alias grep='grep -i --color=tty -d skip'
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias :q='exit'
alias mosh='mosh --predict=experimental'
alias git='nocorrect noglob git'
alias apt='nocorrect noglob apt'
