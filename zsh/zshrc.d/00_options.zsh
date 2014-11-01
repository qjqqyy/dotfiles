setopt autocd autocontinue correct extendedglob extendedhistory histignoredups histignorespace noflowcontrol rcexpandparam sharehistory
autoload -Uz zmv run-help run-help-git ex

HISTFILE=${HISTFILE:-$HOME/.zsh/history}
HISTSIZE=5000
SAVEHIST=$HISTSIZE
KEYTIMEOUT=2

export EDITOR='vim'
export VISUAL='vim'

# only linux sorts like a bitch
[[ $OSTYPE =~ bsd ]] || export LC_COLLATE='C'
export TZ='Asia/Singapore'
