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

if hash vim > /dev/null 2>&1; then
  EDITOR='vim'
  VISUAL='vim'
  alias vi=vim
else
  EDITOR='vi'
fi
if hash less > /dev/null 2>&1; then
  PAGER=${PAGER:-less}
fi
if hash doas > /dev/null 2>&1; then
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
