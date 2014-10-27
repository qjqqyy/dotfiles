case $TERM in
  termite|*xterm*|konsole|konsole-256color|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term|screen*)
    # Solarized dircolors for graphical terminals
    eval `dircolors -b $HOME/.zsh/.dircolors`
    ;;
  *)
    eval `dircolors -b`
    ;;
esac
