# path of . relative to $HOME
DOTPATH ?= .dotfiles

.PHONY: zsh
zsh: ~/.zsh ~/.zshrc

~/.zsh:
	ln -sf $(DOTPATH)/zsh $@

~/.zshrc: ~/.zsh
	ln -sf .zsh/zshrc $@

.PHONY: vim
vim: ~/.vim

~/.vim:
	ln -sf $(DOTPATH)/vim $@

.PHONY: nvim
nvim: ~/.config/nvim/init.vim

~/.config/nvim/init.vim: init.vim
	mkdir -p $(dir $@)
	ln -sf ../../$(DOTPATH)/$< $@

.PHONY: tmux
tmux: ~/.tmux.conf

~/.tmux.conf: tmux.conf
	ln -sf $(DOTPATH)/$< $@

.PHONY: git
git: ~/.config/git/config

~/.config/git/config: gitconfig
	mkdir -p $(dir $@)
	install -m644 $< $@

.PHONY: xmonad
xmonad: ~/.xmonad/xmonad.hs ~/.xmobar/xmobar.hs ~/bin/i3lock_wrapper

~/.xmonad/xmonad.hs: xmonad/xmonad.hs
	ln -sf ../$(DOTPATH)/$< $@

~/.xmobar/xmobar.hs: xmonad/xmobar.hs
	ln -sf ../$(DOTPATH)/$< $@

~/bin/i3lock_wrapper: xmonad/i3lock_wrapper
	install -m755 $< $@
