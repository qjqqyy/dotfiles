# Syntax highlighting
if [[ -r /usr/local/share/zsh/plugins/zsh-syntax-highlighting/zyn-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh/plugins/zsh-syntax-highlighting/zyn-syntax-highlighting.zsh
elif [[ -r /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
