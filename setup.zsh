#!/bin/zsh
#.git/  vim/  zsh/  .gitignore  tmux.conf
DIR=${1:-.dotfiles}
ln -s $DIR/vim $HOME/.vim
ln -s $DIR/vim/vimrc $HOME/.vimrc

ln -s $DIR/zsh $HOME/.zsh
ln -s $DIR/zsh/zshrc $HOME/.zshrc

ln -s $DIR/tmux.conf $HOME/.tmux.conf
