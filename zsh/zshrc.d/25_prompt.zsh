[[ $TERM =~ (rxvt|screen|tmux) ]] && ZLE_RPROMPT_INDENT=0
if autoload -Uz prompt; then
    # check SSH
    if [[ -n $TMUX ]]; then
        prompt
    elif [[ -n $SSH_CLIENT ]]; then
        prompt ssh
    else
        prompt
    fi
else
    # fallback prompt
    PROMPT='%n@%m:%~ %# '
fi
