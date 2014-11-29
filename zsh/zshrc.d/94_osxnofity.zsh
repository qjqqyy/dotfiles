if [[ $OSTYPE =~ darwin && -x =terminal-notifier ]]; then
    function growl(){ 
        terminal-notifier -activate com.googlecode.iterm2 -title "iTerm 2" -subtitle $(print -Pn %n@%m:%d) -message "$@ finished" 
    }
fi
