# colors needed by openbsd grep alias
#autoload -Uz colors #vcs_info
#colors
POWERLINE_FONTS=${POWERLINE_FONTS:-YES}
if [[ $POWERLINE_FONTS =~ ^[yY][eE][sS]$ ]]; then
    PROMPT="%K{green}%F{black}%B %n@%m %b%F{green}%K{11}%F{11}%K{9}%F{black} %~ %F{9}%K{reset}%F{reset} "
    
    RPROMPT_VI="%F{11}%F{blue}%K{11}%B INSERT %b%K{11}"
    RPROMPT_BASE="%F{8}%K{8}%F{10} %* "
    RPROMPT_RETURN="%(?.%F{green}%K{green}%F{black} ✓.%F{red}%K{red}%F{black} %? ✘) "
else
    if [[ $UID -eq 0 ]]; then
        PROMPT="%B%K{red}%n%b%K{reset}@%F{cyan}%m%F{reset}:%F{yellow}%~%F{reset} %# "
    else 
        PROMPT="%F{cyan}%n%F{reset}@%F{cyan}%m%F{reset}:%F{yellow}%~%F{reset} %# "
    fi
    RPROMPT_BASE="%F{green}%* %F{reset}[%F{magenta}%?%F{reset}]"
fi
RPROMPT="$RPROMPT_RETURN$RPROMPT_VI$RPROMPT_BASE"
