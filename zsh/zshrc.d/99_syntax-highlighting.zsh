# Syntax highlighting
if  [[ -r ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] 
then
  source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zyn-syntax-highlighting.zsh ]]
then
   source /usr/share/zsh/plugins/zsh-syntax-highlighting/zyn-syntax-highlighting.zsh
elif [[ -r /usr/local/share/zsh/plugins/zsh-syntax-highlighting/zyn-syntax-highlighting.zsh ]]
then
   source /usr/local/share/zsh/plugins/zsh-syntax-highlighting/zyn-syntax-highlighting.zsh
fi;
