" for neovim: place in ~/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
au VimLeave * set guicursor=a:hor25-blinkon1
source ~/.vim/vimrc
