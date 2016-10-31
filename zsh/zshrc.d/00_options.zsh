setopt autocd autocontinue correct extendedglob extendedhistory histignoredups histignorespace noflowcontrol rcexpandparam sharehistory
autoload -Uz zmv run-help run-help-git ex colors
colors

HISTFILE=${HISTFILE:-$HOME/.zsh/history}
HISTSIZE=5000
SAVEHIST=$HISTSIZE
KEYTIMEOUT=2

if hash vim > /dev/null 2>&1; then
    export EDITOR='vim'
    export VISUAL='vim'
    alias vi=vim
else
    export EDITOR='vi'
fi
if hash less > /dev/null 2>&1; then
    export PAGER=${PAGER:-less}
fi

# only linux sorts like a bitch
[[ $OSTYPE =~ (darwin|bsd) ]] || export LC_COLLATE='C'
export TZ='Asia/Singapore'
# *bsd console won't do utf8
[[ TERM =~ ^vt ]] || export LANG=${LANG:-en_US.UTF-8}
export LC_TIME=${LC_TIME:-en_GB.UTF-8}
