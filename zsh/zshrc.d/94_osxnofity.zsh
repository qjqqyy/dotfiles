if [[ $OSTYPE =~ darwin ]]; then
  if hash terminal-notifier > /dev/null 2>&1; then
    function growl(){
      terminal-notifier -activate com.googlecode.iterm2 -title "iTerm 2" -subtitle $(print -Pn %n@%m:%d) -message "$@ finished"
    }
  fi
fi
