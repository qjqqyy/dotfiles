# Aliases
alias cd=' cd'
if  [[ $OSTYPE =~ gnu ]]; then
    alias ls=' ls -FH --group-directories-first --color=auto'
    alias mv='nocorrect noglob timeout 5 mv -iv'
    alias rm='nocorrect noglob timeout 5 rm -Iv --one-file-system'
elif [[ $OSTYPE =~ darwin ]]; then
    alias ls=' ls -FGH'
    alias mv='nocorrect noglob mv -iv'
    alias rm='nocorrect noglob rm -iv'
elif [[ $OSTYPE =~ freebsd ]]; then
    alias ls=' ls -FGH'
    alias mv='nocorrect noglob mv -iv'
    alias rm='nocorrect noglob rm -Ivx'
elif [[ $OSTYPE =~ openbsd ]]; then
    alias ls=' ls -FH'
    alias mv='nocorrect noglob mv -i'
    alias rm='nocorrect noglob rm -i'
fi
alias ll='ls -l'
alias la='ls -A'
alias lla='ll -A'
alias lh='ll -h'
alias lah='lla -h'
alias :q='exit'
alias cp='cp -i'                          # confirm before overwriting something
if [[ $OSTYPE =~ openbsd ]]; then
    function cgrep () {
        if [[ $# -gt 2 ]]; then
            _IFS=$IFS
            IFS='|'
            #perl -e "print qq+${${${@[2,$#]//\\/\\\\}//|/\\|}//\//\\\/}+"
            _GREP_FILES="${${@[2,$#]//\\/\\\\}//\//\\/}"
            export _GREP_FILES
	    =grep -i $* | perl -ne "my(\$a,\$b)=split /:/,\$_,2; \$a =~ s/^(\$ENV{_GREP_FILES})\$/${fg[magenta]}\$1${fg[cyan]}:${reset_color}/; \$b =~ s/(${1})/${bold_color}${fg[red]}\$1${reset_color}/gi; print qq!\$a\$b!"
            IFS=$_IFS
            unset _GREP_FILES _IFS
        elif [[ $# -eq 0 ]]; then
            print "usage: $0 [NO OPTIONS SUPPORTED] [pattern] [file ...]"
        else
            =grep -i $* | perl -pe "s/(${1})/${bold_color}${fg[red]}\$1${reset_color}/gi" 
        fi
    }
    alias grep='grep -i'
else
    alias grep='grep -i --color=auto -d skip'
fi
alias df='df -h'                          # human-readable sizes
[[ $OSTYPE =~ linux ]] && alias free='free -m'  # show sizes in MB
alias git='nocorrect noglob git'
# force mouse off
alias mousereset=" printf '\033[?1002l'"
