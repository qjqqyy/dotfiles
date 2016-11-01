# colors needed by openbsd grep alias
#autoload -Uz colors #vcs_info
#colors
if [[ $UID -eq 0 ]]; then
    PROMPT="%{$bg_bold[red]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%} %# "
else 
    PROMPT="%F{cyan}%n%F{reset}@%F{cyan}%m%F{reset}:%F{yellow}%~%F{reset} %# "
fi
RPROMPT_="%F{green}%* %F{reset}[%F{magenta}%?%F{reset}]"
RPROMPT=$RPROMPT_
