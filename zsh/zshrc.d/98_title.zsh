#------------------------------
# Window title
#------------------------------
case $TERM in
  termite|*xterm*|konsole|konsole-256color|(dt|k|E)term)
    precmd () {
      print -Pn "\e]0;%n@%m:%d\a"
    }
#    preexec () { print -Pn "\e]0;%n@%m:%d ($1)\a" }
    ;;
  *rxvt*)
    precmd () {
      print -Pn "\e]0;%n@%m:%d\a"
    }
    preexec () {
      print -Pn "\e]0;%n@%m:%d "
      print -n "(${(q)1//[[:space:]]/ })\a"
    }
    ;;
#  screen|screen-256color)
#    precmd () {
##      vcs_info
#      print -Pn "\e]83;title \"$1\"\a"
#      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
#    }
#    preexec () {
#      print -Pn "\e]83;title \"$1\"\a"
#      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
#    }
#    ;;
esac
