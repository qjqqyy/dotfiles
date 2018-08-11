setopt autocd autocontinue correct extendedglob extendedhistory histignoredups
setopt histignorespace noflowcontrol rcexpandparam sharehistory
autoload -Uz zmv run-help run-help-git ex colors
colors

# ignore autocorrect to autocomplete definitions
CORRECT_IGNORE='_*'
HISTFILE=${HISTFILE:-$HOME/.zsh/history}
HISTSIZE=5000
SAVEHIST=$HISTSIZE
KEYTIMEOUT=2

if hash nvim &>/dev/null; then
  EDITOR='nvim'
  VISUAL='nvim'
  alias vi=nvim
  alias vim=nvim
elif hash vim &>/dev/null; then
  EDITOR='vim'
  VISUAL='vim'
  alias vi=vim
else
  EDITOR='vi'
fi
if [[ -x $HOME/.vim/plug/vimpager/vimpager ]]; then
  export GIT_PAGER=less
  PAGER=$HOME/.vim/plug/vimpager/vimpager
  alias less=$PAGER
elif hash less &>/dev/null; then
  PAGER=${PAGER:-less}
fi
if [[ -x $HOME/.vim/plug/vimpager/vimcat ]]; then
  READNULLCMD=$HOME/.vim/plug/vimpager/vimcat
  alias vimcat=$READNULLCMD
fi
if hash doas &>/dev/null; then
  alias sudo='doas'
fi

TZ=${TZ:-Asia/Singapore}
LC_COLLATE='C'
LC_TIME=${LC_TIME:-en_GB.UTF-8}
LANG=${LANG:-en_US.UTF-8}
export EDITOR VISUAL PAGER TZ LC_COLLATE LC_TIME LANG

if [[ $OSTYPE =~ freebsd ]]; then
  # sanitize $TERM
  case $TERM in
    *konsole*)
      TERM=xterm-256color
      ;;
    *tmux*)
      TERM=screen-256color
      ;;
  esac
fi
