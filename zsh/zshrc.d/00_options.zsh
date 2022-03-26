setopt autocd autocontinue correct extendedglob extendedhistory histignoredups
setopt histignorespace noflowcontrol rcexpandparam sharehistory
autoload -Uz zmv run-help run-help-git ex colors
colors

# ignore autocorrect to autocomplete definitions
CORRECT_IGNORE='_*'
HISTFILE=$HOME/.zsh/history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
KEYTIMEOUT=2

if (( $+commands[nvim] )); then
  EDITOR='nvim'
  VISUAL='nvim'
  alias vi=nvim
  alias vim=nvim
elif (( $+commands[vim] )); then
  EDITOR='vim'
  VISUAL='vim'
  alias vi=vim
else
  EDITOR='vi'
fi
if [[ -z "$PAGER" && -x $HOME/.vim/plug/vimpager/vimpager ]]; then
  PAGER=$HOME/.vim/plug/vimpager/vimpager
  alias less=$PAGER
elif (( $+commands[less] )); then
  PAGER=${PAGER:-less}
fi
if [[ -x $HOME/.vim/plug/vimpager/vimcat ]]; then
  READNULLCMD=$HOME/.vim/plug/vimpager/vimcat
  alias vimcat=$READNULLCMD
fi
if (( $+commands[doas] )); then
  alias sudo='doas'
fi

TZ=${TZ:-Asia/Singapore}
LC_COLLATE='C'
LC_TIME=${LC_TIME:-en_GB.UTF-8}
LANG=${LANG:-en_US.UTF-8}
export EDITOR VISUAL PAGER TZ LC_COLLATE LC_TIME LANG

# OS specific stuff, eg sanitize $TERM for OSes with shitty terminfo
if [[ $OSTYPE =~ freebsd ]]; then
  case $TERM in
    *konsole*)
      TERM=xterm-256color
      ;;
    *tmux*)
      TERM=screen-256color
      ;;
  esac
elif [[ $OSTYPE =~ darwin ]]; then
  if [[ $TERM =~ "rxvt-unicode" && ! -r "$HOME/.terminfo/72/$TERM" ]]; then
    TERM=${TERM//-unicode/}
  fi
  unset LC_CTYPE
  if [[ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]]; then
    hash -d -- icloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  fi
fi
