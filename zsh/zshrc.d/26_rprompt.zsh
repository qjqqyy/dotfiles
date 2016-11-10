if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
        typeset -g __prompt_status="$?"	#RPROMPT
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-finish
else
    function zle-line-init () {
        typeset -g __prompt_status="$?" #RPROMPT
    }
fi
function zle-keymap-select() {
    if [[ $KEYMAP = vicmd ]]; then
	RPROMPT_VI="%F{11}%F{yellow}%K{11}%B NORMAL %b%K{11}"
    else
        RPROMPT_VI="%F{11}%F{blue}%K{11}%B INSERT %b%K{11}"
    fi
    RPROMPT="$RPROMPT_RETURN$RPROMPT_VI$RPROMPT_BASE"
    () { return $__prompt_status }
    zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

