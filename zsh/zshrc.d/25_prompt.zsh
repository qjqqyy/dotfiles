# colors needed by openbsd grep alias
#autoload -Uz colors #vcs_info
#colors
if [[ $UID -eq 0 ]]; then
    PROMPT="%{$bg_bold[red]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}%# "
else 
    PROMPT="%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}%# "
fi
RPROMPT_="%{$fg[green]%}%* %{$reset_color%}[%{$fg[magenta]%}%?%{$reset_color%}]"
RPROMPT=$RPROMPT_
