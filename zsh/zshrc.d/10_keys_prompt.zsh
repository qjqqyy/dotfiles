autoload -Uz colors vcs_info
colors
PROMPT="%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}%# " 
RPROMPT_="%{$fg[green]%}%* [%{$fg[magenta]%}%?%{$reset_color%}]"
RPROMPT=$RPROMPT_
bindkey -v
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" history-beginning-search-forward
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

# misc binds
bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' 'vi-oper-swap-case'
bindkey -a G end-of-buffer-or-history
bindkey -a u undo
bindkey -a '^R' redo
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

