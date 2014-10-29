autoload -Uz colors #vcs_info
colors
PROMPT="%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}%# " 
RPROMPT_="%{$fg[green]%}%* %{$reset_color%}[%{$fg[magenta]%}%?%{$reset_color%}]"
RPROMPT=$RPROMPT_
