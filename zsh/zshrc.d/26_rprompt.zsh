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
    RPROMPT=$RPROMPT_
    [[ $KEYMAP = vicmd ]] && RPROMPT="((CMD))$RPROMPT_"
    () { return $__prompt_status }
    zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

