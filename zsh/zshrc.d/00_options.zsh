setopt autocd autocontinue correct extendedglob extendedhistory histignoredups histignorespace noflowcontrol rcexpandparam sharehistory
autoload -Uz zmv run-help run-help-git ex colors
colors

# ignore autocorrect to autocomplete definitions
CORRECT_IGNORE='_*'
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

export TZ='Asia/Singapore'
export LC_COLLATE='C'
export LC_TIME=${LC_TIME:-en_GB.UTF-8}
[[ TERM =~ ^vt ]] || export LANG=${LANG:-en_US.UTF-8}
