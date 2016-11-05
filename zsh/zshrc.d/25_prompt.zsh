# colors needed by openbsd grep alias
#autoload -Uz colors #vcs_info
#colors
[[ $TERM =~ (rxvt|screen|tmux) ]] && ZLE_RPROMPT_INDENT=0
# Wild guess: if the terminal supports colour I most likely patched the fonts
[[ $TERM =~ color ]] && export POWERLINE_FONTS=${POWERLINE_FONTS:-YES}
if [[ $POWERLINE_FONTS =~ ^[yY][eE][sS]$ ]]; then
    PROMPT="%K{green}%F{black}%B %n@%m %b%F{green}%K{11}%F{11}%K{9}%F{black} %~ %F{9}%k%f "
    PS2="%K{11}%F{8}%B %_ %b%k%F{11}%f "
    RPROMPT_VI="%F{11}%F{blue}%K{11}%B INSERT %b%K{11}"
    RPROMPT_BASE="%F{8}%K{8}%F{10} %D{%H:%M:%S} "
    RPROMPT_RETURN="%F{10}%K{10}%(?.%F{green} ✓.%F{red} %? ✗) "
else
    if [[ $UID -eq 0 ]]; then
        PROMPT="%B%K{red}%n%b%k@%F{cyan}%m%f:%F{yellow}%~%f %# "
    else 
        PROMPT="%F{cyan}%n%f@%F{cyan}%m%f:%F{yellow}%~%f %# "
    fi
    RPROMPT_BASE="%F{green}%* %f[%F{magenta}%?%f]"
fi
RPROMPT="$RPROMPT_RETURN$RPROMPT_VI$RPROMPT_BASE"
