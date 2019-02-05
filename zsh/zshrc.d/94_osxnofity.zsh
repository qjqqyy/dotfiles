if [[ $OSTYPE =~ darwin ]]; then
  if (( $+commands[terminal-notifier] )); then
    function growl(){
      terminal-notifier -activate com.googlecode.iterm2 -title "iTerm 2" -subtitle $(print -Pn %n@%m:%d) -message "$@ finished" -timeout 5 2>/dev/null &|
    }
  fi
fi
