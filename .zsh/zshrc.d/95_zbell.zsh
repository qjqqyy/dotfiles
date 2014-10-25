# get $EPOCHSECONDS. builtins are faster than date(1)
zmodload zsh/datetime || return
#   
# make sure we can register hooks
autoload -Uz add-zsh-hook zbell_begin zbell_end || return

zbell_duration=15

# initialize zbell_ignore if not set
zbell_ignore=($EDITOR less weechat ncmpcpp alsamixer top htop)

# initialize it because otherwise we compare a date and an empty string
# the first time we see the prompt. it's fine to have lastcmd empty on the
# initial run because it evaluates to an empty string, and splitting an
# empty string just results in an empty array.
zbell_timestamp=$EPOCHSECONDS

# register the functions as hooks
add-zsh-hook preexec zbell_begin
add-zsh-hook precmd zbell_end

