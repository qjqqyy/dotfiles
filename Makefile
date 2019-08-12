
.PHONY: zsh
zsh: ~/.zsh ~/.zshrc

~/.zsh: zsh/
	ln -srf $< $@

~/.zshrc: ~/.zsh/zshrc
	ln -srf $< $@

.PHONY: vim
vim: ~/.vim

~/.vim: vim/
	ln -srf $< $@

.PHONY: nvim
nvim: ~/.config/nvim/init.vim

~/.config/nvim/init.vim: init.vim
	mkdir -p $(dir $@)
	ln -srf $< $@

.PHONY: tmux
tmux: ~/.tmux.conf

~/.tmux.conf: tmux.conf
	ln -srf $< $@

